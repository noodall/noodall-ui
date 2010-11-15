@cms
Feature: Change templates
  In order to change the style of a page without the need to delete it a website editor should be able to change the template of a node

  Scenario: Change template
    Given a page exists using the "Page A" template
    And I am editing the content
    When I follow "Change Template"
    And I choose "Page C"
    And I press "Change"
    And I visit the content page
    Then the page should be in the "Page C" template

  Scenario: Cannot change template for "Home" template
    Given a page exists using the "Home" template
    And I am editing the content
    Then I should not see "Change Template"

  Scenario: Cannot cahnge template as parent only allows one sub template
    Given a page exists using the "Page B" template
    And that page has a "Page C" parent
    And I am editing the content
    Then show me the page
    Then I should not see "Change Template"

  Scenario: Prevent Template Change if sub content not allowed in new template
    Given a page exists using the "Page A" template
    And that page has "Page A" subpages
    And that page has a "Page A" parent
    And I am editing the content
    When I follow "Change Template"
    And I choose "Page C"
    And I press "Change"
    Then I should see "Template cannot be changed as sub content is not allowed in this template"
    When I visit the content page
    Then the page should be in the "Page A" template

