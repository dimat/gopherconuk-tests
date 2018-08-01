Feature: Create client

Scenario: Create a user
  Given I know the currently registered users
  When I register a new user
  Then I expect a successful registered user response
  When I get list of all user
  Then I expect to get the new user in the list

Scenario: Create a user when users service is down
  Given the users service is down
  When I register a new user
  Then I expect an internal server error
  When the users service is back up
  When I register the same user again
  Then I expect a successful registered user response

Scenario: Create a user when users service responds with garbage
  Given the users service is broken
  When I register a new user
  Then I expect an internal server error
