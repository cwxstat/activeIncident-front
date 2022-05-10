


.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Mongo

.PHONY: loadmongo
loadmongo: ## docker load mongo
	@.script/loadmongo.sh

.PHONY: unloadmongo
unloadmongo: ## docker load mongo
	@.script/unloadmongo.sh


.PHONY: test
test: ## Go test
	MONGO_URI="mongodb://localhost:27017/?directConnection=true&serverSelectionTimeoutMS=2000"
	go test ./...