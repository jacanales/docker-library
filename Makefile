.ONESHELL:

SHELL := /bin/bash
.SHELLFLAGS := -ec

help:
	@echo 'Usage: make [target] ...'
	@echo
	@echo 'targets:'
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s : | sort)"

.DEFAULT_GOAL := help

%:
	@echo 'Invalid target. type `make help` to get a list of available targets'
	@exit 1

build-php-alpine: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-alpine -t jacanales/php-fpm:alpine-test

build-php-minideb: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-minideb -t jacanales/php-fpm:minideb-test

build-php-legacy: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-old -t jacanales/php-fpm:legacy-test