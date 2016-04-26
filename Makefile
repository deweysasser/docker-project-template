######################################################################
# Constants
######################################################################

OUTPUT=output
TESTS=$(OUTPUT)/test-results
BASE_PORT=8000

# Replace IMAGE with something meaningful for your project
IMAGE=$(notdir $(shell pwd))

TEST_CONTAINER=$(shell echo $(IMAGE)-test-run | tr -d -c a-z_:-)
PORTHASH=tools/port-hash $(BASE_PORT) IMAGE=$(IMAGE)
BUILD_FLAGS=

# The default target -- what happens if you just type 'make'
all: build test

# Build the container from source
build:
	docker build $(BUILD_FLAGS) -t $(IMAGE) source

# Run test cases for the container -- unit, system, what-have-you.  Leave junit compatible XML in output/test-results
# you might also want to create system tests and make the 'test' target depend on systemtest as well
test:  selftest

selftest:
	mkdir -p $(TESTS)
	docker run --name $(TEST_CONTAINER) $(IMAGE) /root/test; re=$$?; docker cp $(TEST_CONTAINER):/test-results $(OUTPUT); docker rm -v $(TEST_CONTAINER); exit $$re

# Run system tests -- how to detect when they're done might be problematical
systemtest: run-systemtest perform-systemtest stop-systemtest
	mkdir -p $(TESTS)
	docker-compose -f docker-compose.yml -f docker-compose.systemtest.yml up -d

perform-systemtest: not-yet-implemented

# Run the container for testing purposes
up: 
	$(PORTHASH) docker-compose up -d

down: 
	$(PORTHASH) docker-compose down

# Run the container with visible output for testing purposes
debug: 
	$(PORTHASH) docker-compose up

# Run a particular flavor -- e.g. 'demo' or 'beta' or perhaps even 'prod' version of the container
run-%: docker-compose.yml docker-compose.%.yml
	$(PORTHASH) docker-compose $(foreach file,$^,-f $(file)) up -d

# Stops a particular flavor -- e.g. 'demo' or 'beta' or perhaps even 'prod' version of the container
stop-%: docker-compose.yml docker-compose.%.yml
	$(PORTHASH) docker-compose $(foreach file,$^,-f $(file)) down

# Clean up all intermediate output, including the test container
clean:
	rm -rf $(OUTPUT)
	-test -n "$$(docker ps -f name=$(TEST_CONTAINER) -q)" && docker rm -f -v $(TEST_CONTAINER) || echo "Container $(TEST_CONTAINER) does not exist"


# Display info about the build environment and create a sourceable 'info.sh' file
info:
	@rm -f info.sh
	@echo IMAGE="$(IMAGE)" >> info.sh
	@echo OUTPUT="$(OUTPUT)" >> info.sh
	@$(PORTHASH) bash -c 'echo DEMO_PORT=$${PORT_$(BASE_PORT)}' >> info.sh
	@cat info.sh


# Generic way to make a compose file
docker-compose.%.yml: docker-compose.%.template.yml
	$(PORTHASH) envsubst < $? > $@


######################################################################
# Insert dependencies here, such as
# run: docker-compose.override.yml
