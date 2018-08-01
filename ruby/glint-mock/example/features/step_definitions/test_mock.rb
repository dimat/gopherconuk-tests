require 'glint-mock'
require 'json'

class TestMock < Glint::Mock::Server
	def prepare_server
		log 'Preparing test mock'

		@server.mount_proc('/test') do |req, res|
			res.body = {
				hello: 'World'
			}.to_json
		end
	end
end

