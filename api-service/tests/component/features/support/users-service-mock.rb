require 'glint-mock'
require 'json'

class UsersServiceMock < Glint::Mock::JsonRpcServer
  def prepare_server
    puts "preparing server"

    @id = 0
    @users = Array.new

    super
  end

  def setup
    class << self
      define_method(:'Users.GetAll') do |params|
        puts "mocked method get all #{@users}"

        {Users: @users}
      end

      define_method(:'Users.Create') do |params|
        puts "mocked method create"

        @id += 1

        user = {
            :Email => params[0]['Email'],
            :Name => params[0]['Name'],
            :Id => @id
        }

        @users.push user

        {Id: @id}
      end
    end
  end
end