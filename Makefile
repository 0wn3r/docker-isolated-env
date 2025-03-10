#!/usr/bin/make

docker_bin := $(shell command -v docker 2> /dev/null)
image_name := dummy
local_android_root := $(word 2, $(MAKECMDGOALS))

.PHONY : build clean help run stop shell
.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker image Usage: $ make build
	$(docker_bin) build -t local/build-env -f ./Dockerfile .;

run: ## Start container. In other case you need to run command manually! Usage: $ make run "local_android_root"
	$(docker_bin) run -itd --name $(image_name) -v $(local_android_root):/home/ubuntu/repo_android -v ~/.gitconfig:/etc/gitconfig local/build-env

stop: ## Stop and remove container. Usage: $ make stop
	$(docker_bin) ps -a -q --filter "name=dummy" | awk '{print $$1 }' | xargs -I {} $(docker_bin) stop {}

shell: ## Start shell into dummy container. Usage: $ make shell
	$(docker_bin) exec -it $(image_name) bash

clean: ## Remove images from local registry. Usage: $ make clean
	$(docker_bin) ps -a -q --filter "name=dummy" | awk '{print $$1 }' | xargs -I {} $(docker_bin) rm -f {} ; \
