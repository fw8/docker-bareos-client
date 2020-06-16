NAME   := freinet/bareos-client
COMMIT_ID := $$(git log -1 --date=short --pretty=format:%cd.%h)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## build the container
	docker build --tag ${NAME}:${COMMIT_ID} .
	docker build --tag ${NAME}:18.2 .
	docker build --tag ${NAME}:latest .

push: ## push to docker hub
	docker push ${NAME}:${COMMIT_ID}
	docker push ${NAME}:18.2
	docker push ${NAME}:latest
