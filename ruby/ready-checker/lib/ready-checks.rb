require 'timeout'
require 'socket'
require 'net/http'

module Glint
  module ReadyChecker
    
    class AbstractCheck
      attr_accessor :name  
    
      def initialize(name)
        @name = name
      end

      def check
        raise 'Not implemented'
      end

      def log(message)
        return unless ENV['DEBUG']
        puts message
        STDOUT.flush
      end
    end

    class UrlContentCheck < AbstractCheck
      public
      def initialize(uri, expect_response_body = nil, expect_response_code = 200)
        super("URL #{uri}")
        @uri = uri
        @uri = URI(uri) if uri.is_a? String
        @expect_response_body = expect_response_body
        @expect_response_code = expect_response_code
      end

      def check
        log "connecting to #{@uri}"
        begin
          http = Net::HTTP.new(@uri.host, @uri.port)
          request = Net::HTTP::Get.new @uri.request_uri
          response = http.request request

          log "response: #{response}"
          log "code: #{response.code}, expecting #{@expect_response_code}"
          log "body: #{response.body}, expecting #{@expect_response_body}"

          return false unless response.code == "#{@expect_response_code}"

          unless @expect_response_body.nil?
            puts 'checking body'
            return false unless response.body == @expect_response_body
          end

          log 'passed'
          return true
        rescue
          return false
        end
      end
    end

    class ServiceReadyCheck < UrlContentCheck
      def initialize(host, port = 80)
        uri = URI("http://#{host}:#{port}/ready")
        super(uri, nil, 200)
        @name = "Service #{host}"
      end
    end
  end
end