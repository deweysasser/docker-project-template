######################################################################
# Constants
######################################################################

OUTPUT=output
TESTS=$(OUTPUT)/test-results

# Replace IMAGE with something meaningful for your project
IMAGE=$(notdir $(shell pwd))
TAG=latest

TEST_CONTAINER=$(shell echo $(IMAGE)-test-run | tr -d -c a-z_-)

all: build test

build:
	cd source; docker build -t $(IMAGE):$(TAG) .

test:
	mkdir -p $(TESTS)
	docker run --name $(TEST_CONTAINER) $(IMAGE):$(TAG) /root/test; re=$$?; docker cp $(TEST_CONTAINER):/test-results $(OUTPUT); docker rm -v $(TEST_CONTAINER); exit $$re

run: 
	docker-compose up -d

debug: 
	docker-compose up


docker-compose.override.yml: docker-compose.override.template.yml
	envsubst < $? > $@

clean:
	rm -rf $(OUTPUT)
	-test -n "$$(docker ps -f name=$(TEST_CONTAINER) -q)" && docker rm -f -v $(TEST_CONTAINER) || echo "Container $(TEST_CONTAINER) does not exist"

info:
	@echo IMAGE is $(IMAGE)
	@echo OUTPUT dir is $(OUTPUT)


######################################################################
# Insert dependencies here, such as
# run: docker-compose.override.yml
