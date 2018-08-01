require 'net/http'
require 'webrick'
require 'timeout'

module WEBrick
  module HTTPServlet
    class ProcHandler
      alias do_PUT do_GET
      alias do_DELETE do_GET
    end
  end
end

module Glint
  module Mock
    # A wrapper around a web server that can be spawned in background
    #
    # Normally, it would be good to inherit from Glint::Mock::Server and
    # add the required endpoints in the prepare_server function.
    #
    # For example:
    #   require 'glint-mock'
    #   require 'json'
    #
    #   class TestMock < Glint::Mock::Server
    #     def prepare_server
    #       log 'Preparing test mock'
    #
    #       @server.mount_proc('/test') do |req, res|
    #         res.body = {
    #             hello: 'World'
    #         }.to_json
    #       end
    #     end
    #   end
    #
    # After that it can be used as following:
    #   test_mock = TestMock.new 1234
    #   test_mock.start
    #
    #
    # If it is used within cucumber, then it is good to shutdown all
    # servers at the end of each scenario.
    # In order to do that, add the following lines to features/support/env.rb:
    #   at_exit do
    #     Glint::Mock::shutdown_all
    #   end
    #
    #   After do
    #     Glint::Mock::shutdown_all
    #   end
    class Server
      attr_accessor :server
      attr_reader :uri
      attr_reader :port
      attr_reader :name

      # Initialiser of the server, but it doesn't run it by default.
      # Call .start after initialisation
      #
      # Arguments:
      #   port: (Integer) - TCP port on which the mock server should be listening
      def initialize(port, name = nil)
        @port = port
        @name = name
        @uri = URI.parse("http://localhost:#{port}")

        initialize_server
      end

      def initialize_server
        return false if @server
        configure_logs

        log "Starting server on port #{@port}"

        @server = WEBrick::HTTPServer.new(
            Port: @port,
            Logger: @logger,
            AccessLog: @access_log,
            DoNotReverseLookup: true
        )

        set_health_check
        prepare_server
        Glint::Mock::register(self, name)
      end

      # Should be overridden in the implementation
      def prepare_server;
      end

      def start
        return false unless @server
        log "starting server on port #{@port}"
        @thread = Thread.new do
          @server.start
        end

        wait_until_up
      end

      # Moves the server to the main thread
      # Should be called after calling .start
      def synchronous
        trap('INT') {|_s| stop}

        @thread.join
      end

      def stop
        return false if @server.nil?
        log "shutting down port #{@port}"
        @server.shutdown
        @server = nil

        Glint::Mock::SERVERS.delete(self)
      end

      def stop_and_wait
        stop
        @thread.join
      end

      # Outputs log message only if DEBUG or MOCK_LOGS are enabled
      def log(message)
        puts "#{Time.now}: #{message}" if ENV['DEBUG'] || ENV['MOCK_LOGS']
      end

      private

      def set_health_check
        @server.mount_proc '/health_check' do |_req, res|
          res.status = 200
        end
      end

      def check_server(host, port)
        begin
          log 'pinging...'
          response=nil
          http = Net::HTTP.start(host, port, open_timeout: 1, read_timeout: 1) do |http|
            response = http.head('/health_check')
          end
          return true if response.code == '200'
        rescue Exception => e
          log e
        end
        log 'still down'
        false
      end

      def configure_logs
        @access_log = []
        if ENV['DEBUG'] || ENV['MOCK_LOGS']
          @logger = WEBrick::Log.new STDOUT
          @access_log << [STDOUT, WEBrick::AccessLog::COMBINED_LOG_FORMAT]
        else
          nullfile = File.open '/dev/null', 'a+'
          @logger = WEBrick::Log.new nullfile
        end
      end

      # Most of it taken from https://github.com/calabash/calabash-ios/blob/develop/calabash-cucumber/lib/calabash-cucumber/wait_helpers.rb
      def wait_for(&_block)
        timeout = 30
        retry_frequency = 0.3

        Timeout.timeout(timeout) do
          sleep(retry_frequency) until yield
        end
      end

      def wait_until_up
        log 'waiting for the server to start'
        wait_for do
          check_server 'localhost', @port
        end
        log 'up and running'
      end
    end

  end
end
