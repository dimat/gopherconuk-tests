require 'glint-mock'

module Glint
  module Mock

    class JsonRpcServer < Server
      attr_accessor :requests
      attr_accessor :method
      attr_accessor :params

      def endpoint
        '/rpc'
      end

      def prepare_server
        @requests = []

        @server.mount_proc('/ready') do |req, res|
          res.status = 200
          res.body = 'OK'
        end

        @server.mount_proc(endpoint) do |req, res|
          res.status = 200
          res.content_type = 'application/json'
          jrpc_request = JSON.parse(req.body)
          method = jrpc_request['method']
          params = jrpc_request['params']
          @requests.push({:method => method, :params => params})
          @method = method
          @params = params

          log "Calling method #{method}, with params: #{params}"

          begin
            result = send(method, params)
            log "Successful result: #{result}"
            res.body = {
                jsonrpc: '2.0',
                id: jrpc_request['id'],
                result: result
            }.to_json
          rescue Exception => e
            log "Returning error result: #{e.message}"
            res.body = {
                jsonrpc: '2.0',
                id: jrpc_request['id'],
                error: {
                    code: -32600,
                    message: 'Invalid method parameter(s)',
                    data: e.message
                }
            }.to_json
          end
        end

      end
    end
  end
end

