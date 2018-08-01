require 'glint_requests'

Given(/^I am running mock server$/) do
	@test_mock = TestMock.new 1234, "mock1"
  @test_mock.result = "mock1"
	@test_mock.start
end

Given(/^I am running another mock server$/) do
	@test_mock2 = TestMock.new 1235, "mock2"
	@test_mock2.result = "mock2"
	@test_mock2.start
end


When(/^I test something with mock1$/) do
	resp = http_post @test_mock.uri + '/test', 'hello'.to_json
	puts resp.body
end

When(/^I test something with mock2$/) do
  resp = http_post @test_mock2.uri + '/test', 'hello'.to_json
  puts resp.body
end
