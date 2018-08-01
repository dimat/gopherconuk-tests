require 'glint-proxy'

module Glint
  module Mock
    SERVERS = []

    PROXY = Glint::Mock::GlintProxy.new

    def register(mock, name)
      SERVERS.push(mock)

      unless name.nil?
        PROXY.start

        PROXY.register_mock(mock, name)
      end
    end

    def shutdown_all
      # @type [Glint::Mock::Server]
      list = SERVERS.clone
      list.each do |mock|
        mock.stop
      end

      SERVERS.clear
      PROXY.shutdown
    end

    module_function :shutdown_all
    module_function :register
  end
end
