@javascript
Feature: Preview Content
  In order to have a succinct page title, with a more descriptive browser title
  A website editor
  Will be able to set a separate browser title

  Scenario: Don't set a browser title
    Given I am editing content
    And I fill in "Title" with "Bacon Ipsum"
    When I press "Publish"
    Then the content should be visible on the website
    And the title should be "Bacon Ipsum"
    And the browser title should be "Bacon Ipsum"
    

  Scenario: Set a browser title
    Given I am editing content
    When I fill in "Title" with "Bacon Ipsum"
    And I follow "Advanced"
    And I fill in "Browser Title" with "Ice Cream"
    And I press "Publish"
    And I follow "Show"
    Then the title should be "Bacon Ipsum"
    And the browser title should be "Ice Cream"