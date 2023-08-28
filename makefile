#!/usr/bin/make

# choco install make

.DEFAULT_GOAL := help

##@ Initialize work

init: ## Start a new development environment
	cp .env.example .env
	$(MAKE) dev
	@sleep 10
	$(MAKE) restore
	$(MAKE) install
	$(MAKE) migrate

##@ Docker actions

dev: ## Start containers detached
	docker compose up -d

logs: ## Show the output logs
	docker compose logs

log: ## Open the logs and follow the news
	docker compose logs --follow

restart: ## Restart the app container
	docker compose down
	docker compose up -d

up: ## Put the project UP
	docker compose up -d

down: ## Put the project DOWN
	docker compose down

unlog: ## Clear log file
	docker compose exec nginx bash -c "echo '' > storage/logs/laravel.log"

tinker: ## Start tinker
	docker compose exec --user application nginx bash -c "php artisan tinker"

##@ Bash shortcuts

bash: ## Enter bash nginx container
	docker compose exec --user application nginx bash

nginx: ## Enter bash nginx container
	docker compose exec --user application nginx bash

mysql: ## Enter bash mysql container
	docker compose exec mysql bash

##@ Database tools

migration: ## Create migration file
	docker compose exec --user application nginx bash -c "php artisan make:migration $(name)"

migrate: ## Perform migrations
	docker compose exec --user application nginx php artisan migrate

fresh: ## Perform migrations
	docker compose exec --user application nginx php artisan migrate:fresh

rollback: ## Rollback migration
	docker compose exec --user application nginx php artisan migrate:rollback

backup: ## Export database
	docker compose exec mysql bash -c "/var/www/app/.scripts/backup.sh"

##@ Composer

install: ## Composer install dependencies
	docker-compose exec emcash-nginx bash -c "su -c \"composer install\" application"

update: ## Composer install dependencies
	docker compose exec --user application nginx bash -c "composer update"

autoload: ## Run the composer dump
	docker compose exec --user application nginx bash -c "composer dump-autoload"

##@ General commands

route: ## List the routes of the app
	docker compose exec --user application nginx php artisan route:list
