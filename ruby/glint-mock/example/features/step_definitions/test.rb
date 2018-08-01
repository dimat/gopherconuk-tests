require 'glint_requests'

Given(/^I am running mock server$/) do
	@test_mock = TestMock.new 1234
	@test_mock.start
end

When(/^I test something$/) do
	resp = http_post @test_mock.uri + '/test', 'hello'.to_json
	puts resp.body
end
