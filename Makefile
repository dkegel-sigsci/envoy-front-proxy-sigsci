AGENT_SCALE = 1
#if using SigSci agent 3.15.0 you can scale the agent cluster higher
#SigSci agent 3.15.1 clusters should only have one cluster container
#AGENT_SCALE = 3

build:
        docker-compose build

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
