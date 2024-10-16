.PHONY: help

help:
	@echo "T-WEB-600 backend Tasks"
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

migrate: ## Run migrations
	docker exec -it backend mix ecto.rollback --all;
	docker exec -it backend mix ecto.migrate;

seed: ## Run migrations and seed db
	make migrate;
	docker exec -it backend mix run priv/repo/seeds.exs;

migrations: ## List migrations
	docker exec -it backend mix ecto.migrations

force-migrate: ## Force run migrations
	docker exec -it backend mix ecto.drop --force-drop
	docker exec -it backend mix ecto.create
	docker exec -it backend mix ecto.migrate

install: ## Install dependecies
	docker exec -it backend mix deps.get;
	docker exec -it backend mix deps.compile;

test: ## Run tests
	docker exec -it backend mix test;
