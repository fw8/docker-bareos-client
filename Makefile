NAME   := freinet/bareos-client
COMMIT_ID := $$(git log -1 --date=short --pretty=format:%cd.%h)
TAG   := $$(git describe --exact-match --tags $$(git log -n1 --pretty='%h'))
IMG    := ${NAME}:${COMMIT_ID}
GIT_TAGGED := ${NAME}:${TAG}
LATEST := ${NAME}:latest

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## build the container

	docker build --tag freinet/bareos-client:18.2 .
	docker build --tag freinet/bareos-client:latest .

push: ## push to docker hub
	docker push freinet/bareos-client:18.2
	docker push freinet/bareos-client:latest
