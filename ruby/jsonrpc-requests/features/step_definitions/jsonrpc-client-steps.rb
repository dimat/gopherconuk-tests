require 'cucumber'

Then(/^I expect a valid jsonrpc response$/) do
  expect_valid_jsonrpc_response
end

Then(/^the call should be successful$/) do
  expect_success_code
end

Then(/^the response should be successful$/) do
  expect_success_code
  expect_response_to_be_successful
end

Then(/^the response should be failure$/) do
  expect_response_to_be_failure
end

Then(/^the response should be true/) do
  expect_response_to_be_true
end

Then(/^the error message is "(.*)"$/) do |error|
  expect(@last_response_json['error']['data']).to eq(error)
end

Then(/^the response should be STATE_CHANGE_NOT_ALLOWED/) do
  expect(@last_response_json).to include('error')
  @last_response_result = @last_response_json['error']['data']
  expect(@last_response_result).to eq("STATE_CHANGE_NOT_ALLOWED")
end

Then(/^the response should be false/) do
  expect(@last_response_json).not_to include('error')
  expect(@last_response_json).to include('result')
  @last_response_result = @last_response_json['result']
  expect(@last_response_result).to eq(false)
end
