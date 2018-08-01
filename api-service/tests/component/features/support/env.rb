require 'ready-checker'
require 'json'
require 'glint-mock'
require 'jsonrpc-requests'
require 'securerandom'
require 'glint-jsonrpc-mock'

require_relative 'users-service-mock'
require 'api-requests'

at_exit do
  Glint::Mock::shutdown_all
end

Before do
  $users_service_mock.setup
end

# Starting a mock to pass the ready check of the ledger service
$users_service_mock = UsersServiceMock.new 7788, 'users-service'
$users_service_mock.start

# Ready checks
checks = [
    Glint::ReadyChecker::ServiceReadyCheck.new('api-service'),
]

Glint::ReadyChecker::Checker.wait_for checks
