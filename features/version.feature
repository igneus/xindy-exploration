Feature: Version switch
  As a developer writing the first feature
  In order to make sure xindy is available
  I want to see if it is available and answers the --version switch

Scenario: run with --version
  When I run `xindy --version`
  Then the exit status should be 0
  And the output should contain "xindy release:"
