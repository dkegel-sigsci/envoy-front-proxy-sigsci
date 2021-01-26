# Which versions of sigsci-agent and Envoy to use
# For Sigsci, pick from https://docs.signalsciences.net/release/agent/
# For Envoy, pick from https://hub.docker.com/r/envoyproxy/envoy-alpine/tags
#
## Known bad combinations:
## 2021 Jan
#SIGSCI=4.15.0
#ENVOY=v1.17.0

## Known good combinations:
## 2020 Dec
SIGSCI=4.15.0
ENVOY=v1.16.2
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

build:
	docker-compose build --build-arg ENVOY=$(ENVOY) --build-arg SIGSCI=$(SIGSCI)

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
	@echo "Example fetch from service 1"
	curl -v localhost:8000/service/1
	@echo "Example fetch from service 2"
	curl -v localhost:8000/service/2

clean: stop
	docker system prune
