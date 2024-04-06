# This Makefile requires GNU Make.
MAKEFLAGS += --silent

# Settings
C_BLU='\033[0;34m'
C_GRN='\033[0;32m'
C_RED='\033[0;31m'
C_YEL='\033[0;33m'
C_END='\033[0m'

include .env

DOCKER_TITLE=$(PROJECT_TITLE)
DOCKER_CAAS=$(PROJECT_CAAS)
DOCKER_HOST=$(PROJECT_HOST)
DOCKER_PORT_1=$(PROJECT_PORT_1)
DOCKER_PORT_2=$(PROJECT_PORT_2)

CURRENT_DIR=$(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
DIR_BASENAME=$(shell basename $(CURRENT_DIR))
ROOT_DIR=$(CURRENT_DIR)

DOCKER_COMPOSE?=$(DOCKER_USER) docker compose
DOCKER_COMPOSE_RUN=$(DOCKER_COMPOSE) run --rm
DOCKER_EXEC_TOOLS_APP=$(DOCKER_USER) docker exec -it $(DOCKER_CAAS) sh

help: ## shows this Makefile help message
	echo 'usage: make [target]'
	echo
	echo 'targets:'
	egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

# -------------------------------------------------------------------------------------------------
#  System
# -------------------------------------------------------------------------------------------------
.PHONY: hostname fix-permission port-check

hostname: ## shows local machine hostname ip
	echo $(word 1,$(shell hostname -I))

fix-permission: ## sets project directory permission
	$(DOCKER_USER) chown -R ${USER}: $(ROOT_DIR)/

port-check: ## shows this project port availability on local machine
	echo "Checking configuration for "${C_YEL}"$(DOCKER_TITLE)"${C_END}" container:";
	if [ -z "$$($(DOCKER_USER) lsof -i :$(DOCKER_PORT_1))" ]; then \
		echo ${C_BLU}"$(DOCKER_TITLE)"${C_END}" > port 1:"${C_GRN}"$(DOCKER_PORT_1) is free to use."${C_END}; \
    else \
		echo ${C_BLU}"$(DOCKER_TITLE)"${C_END}" > port 1:"${C_RED}"$(DOCKER_PORT_1) is busy. Update ./.env file."${C_END}; \
	fi
	if [ -z "$$($(DOCKER_USER) lsof -i :$(DOCKER_PORT_2))" ]; then \
		echo ${C_BLU}"$(DOCKER_TITLE)"${C_END}" > port 2:"${C_GRN}"$(DOCKER_PORT_2) is free to use."${C_END}; \
    else \
		echo ${C_BLU}"$(DOCKER_TITLE)"${C_END}" > port 2:"${C_RED}"$(DOCKER_PORT_2) is busy. Update ./.env file."${C_END}; \
	fi

# -------------------------------------------------------------------------------------------------
#  Enviroment
# -------------------------------------------------------------------------------------------------
.PHONY: env env-set

env: ## checks if docker .env file exists
	if [ -f ./docker/.env ]; then \
		echo ${C_BLU}$(DOCKER_TITLE)${C_END}" docker-compose.yml .env file "${C_GRN}"is set."${C_END}; \
    else \
		echo ${C_BLU}$(DOCKER_TITLE)${C_END}" docker-compose.yml .env file "${C_RED}"is not set."${C_END}" \
	Create it by executing "${C_YEL}"$$ make env-set"${C_END}; \
	fi

env-set: ## sets docker .env file
	echo "COMPOSE_PROJECT_NAME=\"$(DOCKER_CAAS)\"\
	\nCOMPOSE_PROJECT_HOST=$(DOCKER_HOST)\
	\nCOMPOSE_PROJECT_PORT_1=$(DOCKER_PORT_1)\
	\nCOMPOSE_PROJECT_PORT_2=$(DOCKER_PORT_2)\
	\nRABBITMQ_USER=$(RABBITMQ_USER)\
	\nRABBITMQ_PASS=$(RABBITMQ_PASS)\
	\nRABBITMQ_COOKIE=$(RABBITMQ_COOKIE)\
	\nRABBITMQ_NODENAME=\"$(RABBITMQ_NODENAME)\"" > ./docker/.env; \
	echo ${C_BLU}"$(DOCKER_TITLE)"${C_END}" docker-compose.yml .env file "${C_GRN}"has been set."${C_END};

# -------------------------------------------------------------------------------------------------
#  Container
# -------------------------------------------------------------------------------------------------
.PHONY: ssh build up start stop restart clear destroy dev

ssh: ## enters the container shell
	$(DOCKER_EXEC_TOOLS_APP)

build: ## builds the container from Dockerfile
	cd docker && $(DOCKER_COMPOSE) up --build --no-recreate -d

up: ## attaches to containers for a service and also starts any linked services
	cd docker && $(DOCKER_COMPOSE) up -d

start: ## starts the container running
	cd docker && $(DOCKER_COMPOSE) start

stop: ## stops the container running - data won't be destroyed
	cd docker && $(DOCKER_COMPOSE) stop

restart: ## execute this Makefile "stop" & "start" recipes
	$(MAKE) stop start

clear: ## removes container from Docker running containers
	cd docker && $(DOCKER_COMPOSE) kill || true
	cd docker && $(DOCKER_COMPOSE) rm --force || true
	cd docker && $(DOCKER_COMPOSE) down -v --remove-orphans || true

destroy: ## delete container image from Docker - Docker prune commands still needed to be applied manually
	$(DOCKER_USER) docker rmi rabbitmq:3.13-management-alpine

dev: ## set a development enviroment
	echo ${C_YEL}"\"dev\" recipe has not usage in this project"${C_END};
