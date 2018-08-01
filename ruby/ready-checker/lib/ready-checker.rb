require 'timeout'
require 'socket'
require 'net/http'
require_relative 'ready-checks.rb'

module Glint

  module ReadyChecker

    class Checker

      public

      # @param [Array<AbstractChecker>] checks
      # @param [Integer] timeout seconds to complete
      def self.wait_for(checks, timeout = 180)
        pending_checks = checks.dup

        generic_wait_for(timeout) do
          passed_checks = []

          pending_checks.each do |check|
            if check.check
              puts "Ready Checker: #{check.name} is ready"
              passed_checks.push(check)
            else
              puts "Ready Checker: #{check.name} is not ready"
            end
          end

          pending_checks -= passed_checks
          STDOUT.flush
          pending_checks.empty?
        end
      end

      private

      def self.generic_wait_for(timeout, &_block)
        retry_frequency = 2

        Timeout.timeout(timeout) do
          sleep(retry_frequency) until yield
        end
        puts 'Everything is ready'
        STDOUT.flush
      end
    end
  end
end