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

build-php-fpm:
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-fpm -t jacanales/php-fpm:test .

build-php-fpm-dev:
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-fpm -t jacanales/php-fpm:test . --target dev

bash:
	docker run --rm -it jacanales/php-fpm:test /bin/bash

build-php-alpine: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-alpine -t jacanales/php-fpm:alpine-test

build-php-minideb: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-minideb -t jacanales/php-fpm:minideb-test

build-php-legacy: ## Build PHP Image
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-old -t jacanales/php-fpm:legacy-test

install-container-test:
	$(BASH) ./bin/install-container-structure-test.sh

tests: ## Run Tests
	container-structure-test test --image jacanales/php-fpm:test --config php-fpm/7.4-fpm/unit-test.yaml

# Push targets
docker-login:
	docker login -u jacanales -p ${PACKAGES} docker.pkg.github.com

docker-build:
	DOCKER_BUILDKIT=1 docker build php-fpm/7.4-fpm -t docker.pkg.github.com/jacanales/danceschool/php:7.4

docker-push: docker-login docker-build-php
	docker push docker.pkg.github.com/jacanales/danceschool/php:7.4