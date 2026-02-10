.PHONY: build up down logs shell lint lint-fix

# ====================================================================================
# HELP
# ====================================================================================
help:
	@echo "Makefile for Django Persistencia Project"
	@echo ""
	@echo "Usage:"
	@echo "    make build          Build the docker images"
	@echo "    make up             Start the services in detached mode"
	@echo "    make down           Stop and remove the services"
	@echo "    make logs           View the logs of the services"
	@echo "    make shell          Get a shell inside the server container"
	@echo "    make lint           Run the ruff linter"
	@echo "    make lint-fix       Run the ruff linter and fix errors automatically"
	@echo ""

# ====================================================================================
# DOCKER COMMANDS
# ====================================================================================
build:
	@echo "Building docker images..."
	docker-compose build

up:
	@echo "Starting services..."
	docker-compose up -d

down:
	@echo "Stopping services..."
	docker-compose down -v

logs:
	@echo "Tailing logs..."
	docker-compose logs -f

shell:
	@echo "Opening shell in server container..."
	docker-compose run --rm servidor bash

# ====================================================================================
# LINTING
# ====================================================================================
lint:
	@echo "Running linter with ruff..."
	ruff check .

lint-fix:
	@echo "Running linter with ruff and fixing errors..."
	ruff check --fix .
