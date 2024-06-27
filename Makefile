.PHONY: all help build
.ONESHELL:
SHELL := /bin/bash
CKAN_VERSION=2.11
PG_IMAGE=15-alpine
IMAGE_NAME=ckan-postgres-dev
TAG_NAME="ckan/$(IMAGE_NAME):$(CKAN_VERSION)"
BASE_IMAGE_NAME=ckan-postgres-dev-base
BASE_IMAGE_TAG_NAME="$(BASE_IMAGE_NAME):$(CKAN_VERSION)"
BASE_CONTAINER := $(shell docker ps | grep ckan-postgres-dev-base | awk '{print $$1}')
CHECK_CONTAINER_NAME=$(IMAGE_NAME)-$(CKAN_VERSION)

all: help
help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


clean: ## Remove previously built images and containers
	@if [ -n "${BASE_CONTAINER}" ]; then
		docker stop $(BASE_CONTAINER)
	fi
	while docker images | grep $(BASE_IMAGE_NAME) ; do
		$(eval IMAGE_ID := $(shell docker images | grep $(BASE_IMAGE_NAME) | awk '{print $$3}'))
		docker rmi $(IMAGE_ID)
	done

	echo "All clear!"

build:	## Build a Postgres image for a specific CKAN / PG image eg `make build CKAN_VERSION=2.8 PG_IMAGE=11-alpine` (defaults are 2.9 and l2-alpine)
	# Build base postgres image
	docker build --build-arg CKAN_VERSION="$(CKAN_VERSION)" --build-arg PG_IMAGE="$(PG_IMAGE)" --no-cache -t $(BASE_IMAGE_TAG_NAME) .
	
	# Run the base container
	docker run --rm --detach --name $(BASE_IMAGE_NAME) $(BASE_IMAGE_TAG_NAME)

	# Wait for the init scripts to run (TODO check actual outputs)
	echo "Waiting for init scripts to run..."
	sleep 6

	# Delete init scripts
	docker exec $(BASE_IMAGE_NAME) rm -rf /docker-entrypoint-initdb.d/*

	# Commit the final image
	docker commit $(BASE_IMAGE_NAME) $(TAG_NAME)

	# Stop (and remove) the base container
	docker stop $(BASE_IMAGE_NAME)

	echo "Created image $(TAG_NAME) using Postgres $(PG_IMAGE)"

check:  ## Starts a tmp container with a generated image and shows the PG version and the list of databases (accepts CKAN_VERSION and PG_IMAGE)
	docker run --rm --detach --name $(CHECK_CONTAINER_NAME) $(TAG_NAME)
	until docker exec -ti $(CHECK_CONTAINER_NAME) pg_isready;
	do
		sleep 1
	done
	docker exec $(CHECK_CONTAINER_NAME) psql --version
	docker exec $(CHECK_CONTAINER_NAME) psql -U postgres -c "\l"
