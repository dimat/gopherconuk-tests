require 'ready-checker'
require 'json'
require 'jsonrpc-requests'
require 'securerandom'

require 'api-requests'

# Ready checks
checks = [
    Glint::ReadyChecker::ServiceReadyCheck.new('users-service'),
    Glint::ReadyChecker::ServiceReadyCheck.new('api-service')
]

Glint::ReadyChecker::Checker.wait_for checks
