######################################################################
# Constants
######################################################################

# Customize your project settings in this file.  If you delete this
# file, a default version will be re-created.  You will likely at
# leats want to specify the ports your container uses.
include project-settings.mk

# Directories
OUTPUT=output
TESTS=$(OUTPUT)/test-results


TEST_CONTAINER=$(shell echo $(IMAGE)-test-run | tr -d -c a-z_:-)
PORTENV=tools/port-env $(PORTS) IMAGE=$(IMAGE)
DOCKER_BUILD_FLAGS=

# The default target -- what happens if you just type 'make'
all: build test

# Build the container from source
build:
	docker build $(DOCKER_BUILD_FLAGS) -t $(IMAGE) source

# Run test cases for the container -- unit, system, what-have-you.
# Leave junit compatible XML in output/test-results you might also
# want to create system tests and make the 'test' target depend on
# systemtest as well

test:  

# Tests the container can run without starting the container in a real environment
selftest:
	mkdir -p $(TESTS)
	-docker rm -f -v $(TEST_CONTAINER)
	docker run --name $(TEST_CONTAINER) $(IMAGE) $(UNITTEST_PROGRAM); re=$$?; docker cp $(TEST_CONTAINER):/test-results $(OUTPUT); docker rm -v $(TEST_CONTAINER); exit $$re

# Run system tests -- how to detect when they're done might be problematical
systemtest: run-systemtest perform-systemtest stop-systemtest

# You will need to implement this 
perform-systemtest: not-yet-implemented

# Run the container for testing purposes
run: 
	$(PORTENV) docker-compose up -d

stop: 
	$(PORTENV) docker-compose down

# Run the container with visible output for testing purposes
debug: 
	$(PORTENV) docker-compose up

# If you need to build things with docker-compose, then...
build-compose:
	docker-compose build

# Generic targets to work with docker-compose building various configurations -- (build|run|stop)-<config>
# <config> might be 'demo' or 'beta' or perhaps even 'prod' version of the container

build-%: docker-compose.yml docker-compose.%.yml
	$(PORTENV) docker-compose $(foreach file,$^,-f $(file)) build

run-%: docker-compose.yml docker-compose.%.yml
	$(PORTENV) docker-compose $(foreach file,$^,-f $(file)) up -d

stop-%: docker-compose.yml docker-compose.%.yml
	$(PORTENV) docker-compose $(foreach file,$^,-f $(file)) down

# Clean up all intermediate output, including the test container
clean:
	rm -rf $(OUTPUT)
	-test -n "$$(docker ps -f name=$(TEST_CONTAINER) -q)" && docker rm -f -v $(TEST_CONTAINER) || echo "Container $(TEST_CONTAINER) does not exist"


# Display info about the build environment and create a sourceable 'info.sh' file
info:
	@rm -f info.sh
	@echo IMAGE="$(IMAGE)" >> info.sh
	@echo OUTPUT="$(OUTPUT)" >> info.sh
	@$(PORTENV) 
	@cat info.sh


# Generic way to make a compose file
docker-compose.%.yml: docker-compose.%.template.yml
	$(PORTENV) envsubst < $? > $@

# If the file is deleted, create a default
project-settings.mk:
	echo "IMAGE=\$$(notdir \$$(shell pwd))" > $@
	echo "PORTS=" >> $@

# Just make sure the file exists
recipes.mk:
	touch $@

# Customized build rules, recipes and dependencies
include recipes.mk

