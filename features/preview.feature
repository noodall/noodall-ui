Feature: Preview Content
  A preview function will allow a website editor to view how content will look before they save it

  @javascript
  Scenario: Preview Content
    Given I am editing content
    And I click preview
    Then I should see how the content will look in the website
