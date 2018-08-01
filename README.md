# Purpose
This code is to demonstrate the structure of the tests that allows to create 
various integration tests.

The used technologies in this repo were chosen for simplicity of demonstration:
* jsonrpc
* cucumber + ruby
* in-memory data

# Structure
The project contains two services:
* `users-service` that contains two functions - to create a new user and get list of all users. It exposes jsonrpc interface.
* `api-service` exposes RESTful API for the same functionality and serves as a gateway to `users-service`.

## Users service
For simplicity of the demo, all the users are stored in memory. It uses `github.com/gorilla/rpc/json` package
to for jsonrpc server.

## API service
It provides the following API:

### Create a user
`POST /users`

#### Request
```json
{
  "email": "person@example.com",
  "name": "John Smith"
}
```

#### Response
If successful, then returns `200` status code and user ID in the body.
`400` if the request is malformed or missing email value
`409` if user already exists
`500` if can't reach `users-service`


# Tests
Current example contains two sets of tests for the `api-service`: component and integration tests.

Component tests cover the public API of the `api-service` mocking the `users-service`.
Having full control of the mock from the tests it can cover edge cases such as connectivity problem,
or unexpected errors.

Integration tests in this example is also an end-to-end set, which shows how multiple services
can be tested together. 

# How to use
Build services:

```bash
make build
``` 

Run tests

```bash
make test
```

If you want to rebuild a specific container, then use one of the following commands:
```bash
make api-service
make users-service
make ruby
```


If you want to execute a specific integration, then you can either use `make` as following:
```bash
make test-api-component
make test-api-integration
```

or go directly into the folder with tests, for example, `api-service/tests/component` and
after that execute:
```bash
docker-compose up
```

Don't forget to press `Ctrl-C` after the tests are finished executing.

## Passing parameters
You may want to pass additional parameters to cucumber and that can be achieved by setting them
into `TEST_ARGS` environment variable. Here are a few examples that you can try.

Assuming that you are in `api-service/tests/component` forlder, try following

To enable all debug output including logs from the mock
```bash
TEST_ARGS='DEBUG=1' docker-compose up
```

To run just a single scenario:
```bash
TEST_ARGS='features/create_client.feature:18' docker-compose up
```

# Recommendations

## General
1. Pass URLs to all 3rd party dependencies in environment variables to be able to connect the service to mocks
2. Extract all repeated Ruby functions and cucumber step definitions into gems to avoid code duplication in multiple
test sets

## Databases
1. Better to install schemas using some DB management tool, such as www.sqitch.org. This can be wrapped
in a separate container and deployed together with tests
2. When a single DB container is shared among multiple services, sqitch for multiple containers shall be run
sequentially

## Continuous Integration
1. Set `TAG` environment variable to a unique value, for example, timestamp
2. Set `COMPOSE_PROJECT_NAME` to either branch name or something unique
3. Avoid using `ports` and external volumes in tests' `docker-compose.yml`
