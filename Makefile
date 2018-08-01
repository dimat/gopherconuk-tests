SERVICES=$(wildcard *-service) ruby

.PHONY: build
build-services: $(SERVICES)

.PHONY: subdirs $(SERVICES)
$(SERVICES):
	@echo "Building $@"
	cd $@ && docker-compose -f docker-compose.build.yml build

.PHONY: test
test: test-api-component test-api-integration

.PHONY: test-api-component
test-api-component:
	cd api-service/tests/component && \
	docker-compose up --exit-code-from tests

.PHONY: test-api-integration
test-api-integration:
	cd api-service/tests/integration && \
	docker-compose up --exit-code-from tests
