def get_all_users
  @last_response = http_get_plain URI.parse('http://api-service/users')

  expect_success_code
  @last_response_json = JSON.parse(@last_response.body)

  expect(@last_response_json).to be_a_kind_of(Array)

  @last_response_json
end

def register_user request
  @last_response = http_post URI.parse('http://api-service/users'), request.to_json
end

def register_random_user
  @last_registered_email = "#{SecureRandom.uuid}@example.com"
  @last_registered_name = "Test user"

  request = {
      email: @last_registered_email,
      name: @last_registered_name
  }

  register_user request
end