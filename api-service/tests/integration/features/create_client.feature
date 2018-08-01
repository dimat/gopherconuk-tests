Feature: Create client

Scenario: Create a user
  Given I know the currently registered users
  When I register a new user
  Then I expect a successful registered user response
  When I get list of all user
  Then I expect to get the new user in the list

Scenario: Create the same user
  When I register a new user
  Then I expect a successful registered user response
  When I register the same user again
  Then I expect to get an user already exists error

Scenario: Create a user with missing email
  When I register a user without email
  Then I expect to get an bad request error