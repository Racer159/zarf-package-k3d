ARCH ?= amd64
VERSION ?= v1.27.2-k3s1

build: ## Build this package as a Zarf `init` package
	zarf package create . --confirm --set K3S_VERSION=$(VERSION) -a $(ARCH)

build-image: ## Build a local version of the `k3s` airgap image
	docker buildx build --platform linux/$(ARCH) --build-arg K3S_VERSION=$(VERSION) --tag racer159/k3s-airgap:$(VERSION) . --progress plain

release-image: ## Release the `k3s` airgap image to DockerHub
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --build-arg K3S_VERSION=$(VERSION) --tag racer159/k3s-airgap:$(VERSION) .

.PHONY: help
help: ## Display this help information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort | awk 'BEGIN {FS = ":.*?## "}; \
	  {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
