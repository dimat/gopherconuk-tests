require 'webrick'
require 'webrick/httpproxy'

module Glint
  module Mock
    class HttpProxy < WEBrick::HTTPProxyServer
      attr_accessor :proxies

      def initialize
        super({Port: 80}, WEBrick::Config::HTTP)
        @proxies = {}
      end

      def service(req, res)
        proxy_service(req, res)
      end

      def proxy_uri(req, res)
        puts "proxy auth for host2: #{req.host}, uri=#{req.request_uri}" if ENV['DEBUG']
        uri = req.request_uri.dup
        mock = @proxies[req.host]

        if mock.nil?
          puts "host #{req.host} not found" if ENV['DEBUG']
          return uri
        end

        uri.host = 'localhost'
        uri.port = mock.port

        puts "found mock for host #{req.host}. Redirecting to port #{uri.port}" if ENV['DEBUG']

        return uri
      end
    end

    class GlintProxy
      def initialize
        @proxy = nil
        @thread = nil
      end

      def start
        return unless @proxy.nil?

        @proxy = HttpProxy.new

        @thread = Thread.new do
          @proxy.start
        end
      end

      def register_mock(mock, name)
        return if @proxy.nil?
        @proxy.proxies[name] = mock
      end

      def shutdown
        return if @proxy.nil?
        @proxy.proxies.clear

        @proxy.shutdown
        @proxy = nil
      end

    end
  end
end

