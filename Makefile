# Which versions of sigsci-agent and Envoy to use
# For Sigsci, pick from https://docs.signalsciences.net/release/agent/
# For Envoy, pick from https://hub.docker.com/r/envoyproxy/envoy-alpine/tags
# Leave all but the combination of interest commented out

#---------- Envoy V3 ---------
# Envoy 1.17 and up use the v3 api, so give it the -v3.yaml example files.
## 2021 Jan
ENVOYARGS=
APISUFFIX=-v3
SIGSCI=4.16.0
ENVOY=v1.17.0

#---------- Envoy V2, forced ---------
# Envoy 1.17 and up disable the V2 api; to use it anyway, run with --bootstrap-version 2, see https://www.envoyproxy.io/docs/envoy/latest/faq/api/transition

## 2021 Jan
#ENVOYARGS=--bootstrap-version 2
#APISUFFIX=
#SIGSCI=4.15.0
#ENVOY=v1.17.0

#---------- Envoy V2 ---------
# Leave ENVOYARGS and APISUFFIX blank for V2
## 2020 Dec
#SIGSCI=4.15.0
#ENVOY=v1.16.2
## 2020 Jun 25
#SIGSCI=4.10.0
#ENVOY=v1.13.3
## 2020 Jun 8 a
#SIGSCI=4.9.0
#ENVOY=v1.14.2
## 2020 Jun 8 b
#SIGSCI=4.9.0
#ENVOY=v1.13.3
## 2020 Jun 8 c
#SIGSCI=4.9.0
#ENVOY=v1.12.4
## 2020 May
#SIGSCI=4.8.0
#ENVOY=v1.14.1
## 2020 Apr
#SIGSCI=4.7.0
#ENVOY=v1.14.1
## 2020 Mar
#SIGSCI=4.6.0
#ENVOY=v1.13.1
## 2020 Jan
#SIGSCI=4.4.1
#ENVOY=v1.13.0
## 2019 Dec
#SIGSCI=4.3.0
#ENVOY=v1.12.2
## 2019 Nov
#SIGSCI=4.2.0
#ENVOY=v1.12.1
## 2019 Oct
#SIGSCI=4.1.0
#ENVOY=v1.12.0
## 2019 Sept
#SIGSCI=3.27.0
#ENVOY=v1.11.1
## 2019 April
#SIGSCI=3.23.0
#ENVOY=v1.9.1
## 2018 December / 2019 April
#SIGSCI=3.15.0
#ENVOY=v1.9.1

AGENT_SCALE = 1
#if using SigSci agent 3.15.0 you can scale the agent cluster higher
#SigSci agent 3.15.1 clusters should only have one cluster container
#AGENT_SCALE = 3

# pass environment variable to docker-compose
export APISUFFIX

build:
	docker-compose build --build-arg ENVOY=$(ENVOY) --build-arg SIGSCI=$(SIGSCI) --build-arg ENVOYARGS="$(ENVOYARGS)"

start:
	docker-compose up -d --scale sigsci-agent=$(AGENT_SCALE)
	@echo
	@echo "For logs: docker-compose logs -f"
	@echo "Or: make log"
	@echo

stop: ## Stop the system
	docker-compose down

log:
	docker-compose logs -f

check: test
test:
	if docker-compose ps | grep Exit; then echo 'Something broke!'; exit 1; fi
	@echo "Example fetch from service 1"
	curl -v localhost:8000/service/1
	@echo "Example fetch from service 2"
	curl -v localhost:8000/service/2
	@echo "Example POST to service 1, just to trigger logging in wasmfilter"
	curl -v -d "param1=value1" localhost:8000/service/1 || true
	docker-compose logs | grep WASM

clean: stop
	docker system prune
