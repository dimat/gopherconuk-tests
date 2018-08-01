Given("I know the currently registered users") do
  @all_users = get_all_users
end

When("I register a new user") do
  register_random_user
end

Then("I expect a successful registered user response") do
  expect_created_response
end

When("I get list of all user") do
  @new_users = get_all_users
end

Then("I expect to get the new user in the list") do
  expect(@new_users.length).to be(@all_users.length + 1)

  contains_new_user = @new_users.any? { |u| u['Email'] == @last_registered_email && u['Name'] == @last_registered_name}
  expect(contains_new_user).to be true
end

When(/^I register the same user again$/) do
  request = {
      email: @last_registered_email,
      name: @last_registered_name
  }
  register_user request
end

Then(/^I expect to get an user already exists error$/) do
  expect_conflict_response
end

When(/^I register a user without email$/) do
  request = {
      name: "Hello"
  }
  register_user request
end

Then(/^I expect to get an bad request error$/) do
  expect_bad_request_response
end
