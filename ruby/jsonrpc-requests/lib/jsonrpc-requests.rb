require 'net/http'

def reset_last_response
  @last_response = nil
  @last_response_json = nil
  @last_response_result = nil
end

def expect_success_code
  expect(Integer(@last_response.code)).to be_between(200, 299)
end

def expect_created_response
  expect(@last_response.code).to eq("201")
end

def expect_conflict_response
  expect(@last_response.code).to eq("409")
end

def expect_bad_request_response
  expect(@last_response.code).to eq("400")
end

def expect_internal_server_error_response
  expect(@last_response.code).to eq("500")
end

def expect_response_to_be_failure
  puts "@last_response_json" if ENV['DEBUG']
  puts @last_response_json if ENV['DEBUG']
  expect(@last_response_json).to include('error')
  @last_response_result = @last_response_json['error']
  puts @last_response_result if ENV['DEBUG']
end

def expect_valid_jsonrpc_response
  puts '@last_response' if ENV['DEBUG']
  puts @last_response if ENV['DEBUG']
  expect(@last_response).to_not be_nil
  expect(@last_response.code).to eq("200")
  @last_response_json = JSON.parse(@last_response.body)
  expect(@last_response_json).to_not be_nil
end

def expect_response_to_be_successful
  puts @last_response_json if ENV['DEBUG']
  expect(@last_response_json).not_to include('error')
  expect(@last_response_json).to include('result')
  @last_response_result = @last_response_json['result']
end

def expect_response_to_be_true
  expect(@last_response_json).not_to include('error')
  expect(@last_response_json).to include('result')
  @last_response_result = @last_response_json['result']
  expect(@last_response_result).to eq(true)
end

def check_valid_jsonrpc_and_successful_response()
  expect_valid_jsonrpc_response
  expect_response_to_be_successful
end

def check_valid_jsonrpc_and_error_response(params={})
  expect_valid_jsonrpc_response
  expect_response_to_be_failure
  puts params[:error] if ENV['DEBUG']
  puts @last_response_result['data'] if ENV['DEBUG']
  expect(@last_response_result['data']).to eq(params[:error])
end

def verify_successful_response
  check_valid_jsonrpc_and_successful_response
  @last_response_json
end

def verify_error_response (error)
  check_valid_jsonrpc_and_error_response(error)
  @last_response_json
end

def call_service(uri, method, params)
  puts "method:  #{method}  and params: #{params}" if ENV['DEBUG']
  @last_response = jsonrpc2(uri, method, params)
end

def jsonrpc2(uri, method, params)
  body = {
    jsonrpc: '2.0',
    method: method,
    params: params,
    id: 1
  }.to_json

  puts "jsonrpc request: #{body}" if ENV['DEBUG']

  puts uri if ENV['DEBUG']
  response = http_post uri, body

  if response
    puts "jsonrpc response: #{response.body}" if ENV['DEBUG']
  end

  response
end

def http_get_plain(uri, headers = { })
  headers = { 'Content-Type' => 'application/json' }.merge(headers)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri, headers)

  begin
    return http.request request
  rescue Exception => e
    puts e
    return nil
  end
end

def http_get(uri, body, headers = { })
  if !body.empty?
    uri.query = URI.encode_www_form(body)
  end

  http_get_plain uri, headers
end

def http_post(uri, body, headers = { })
  headers = { 'Content-Type' => 'application/json' }.merge(headers)

  connect_uri = uri.clone

  unless $rewrite_hosts.nil? || $rewrite_hosts[uri.host].nil?
    connect_uri.host = $rewrite_hosts[uri.host].host
    connect_uri.port = $rewrite_hosts[uri.host].port
    connect_uri.scheme = $rewrite_hosts[uri.host].scheme
    headers['Host'] = uri.host
  end

  http = Net::HTTP.new(connect_uri.host, connect_uri.port)
  if uri.to_s.include? 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request = Net::HTTP::Post.new(uri.request_uri, headers)

  request.body = body

  begin
    return http.request request
  rescue Exception => e
    puts e
    return nil
  end
end
