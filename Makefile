AGENT_SCALE = 3

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
