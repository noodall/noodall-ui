@javascript
Feature: Show popular tags
  In order that I don't reuse tags as can see what other tags are
  As a website editor
  I want to see popular tags next to the tag input box

  Scenario: Popular tags selector
    Given the following page as exists:
      | Title | Tag list                |
      | One   | stuff, things, what, eh |
      | Two   | stuff, things, what     |
      | One   | stuff, things           |
      | One   | stuff                   |
    And I am editing content
    Then I should see the tags list
    When I follow "stuff" within the tag list
    Then the "Keywords" field should contain "stuff"
