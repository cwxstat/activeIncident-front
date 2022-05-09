
.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)



##@ Tools

.PHONY: tools
tools: ## All software: KinD, Kubectl
	@./.scripts/install-kind.sh  
	@./.scripts/install-kubectl.sh
	@./.scripts/install-kubectx.sh


##@ All targets.

.PHONY: complete-kind
complete-kind: tools kind metal   ## All - does everything


##@ Steps

.PHONY: kind 
kind: ## Build Kubernetes cluster named  'metal'
	kind delete cluster --name=metal
	kind create cluster --name=metal --config configs/kind_ingress_metal.yaml
	@./scripts/wait-for-cluster.sh


.PHONY: metal
metal: ## Install metal
	# Metal
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f configs/metal.yaml 


.PHONY: load 
load: ## Load default values like pubsub-key secret, create ns pigbot
	kubectl create ns pigbot
	@scripts/registry-in-pigbot.sh
	kubectl -n pigbot create secret generic pubsub-key --from-file=key.json=/home/codespace/.key/k8s-pubsub-artifact.json
	kubectl patch serviceaccount default -n pigbot  -p '{"imagePullSecrets": [{"name": "artifact-registry"}]}'

.PHONY: service-account 
service-account: ## update service account do images can be pulled. Only works for default ns
	@./scripts/kindadj.sh

.PHONY: cert-manager 
cert-manager: ## cert-manager v1.7.2
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.2/cert-manager.yaml

