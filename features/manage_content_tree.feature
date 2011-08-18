Feature: Manage Content Tree
  In order to provide up to date information in a structured manner on the website a website editor will be able to manage the content in a tree structure

  Background:
    Given the website has been populated with content based on the site map

  Scenario: Browse Content Tree
    Given I am on the content admin page
    Then I should see a list of the roots
    When I click on a root
    Then I should see a list the of the root's children
    When I click on a child
    Then I should see a list of the child's children

  Scenario: Create Root Content
    Given I am on the content admin page
    Then I should be able to create a new root
    And I should see the root listed within the roots

  Scenario: Create Sub Content
    Given I am on the content admin page
    When I click on a root
    Then I should be able to create a new child
    And I should see the child listed within the root's children

  Scenario: Delete Content
    Given I am on the content admin page
    Then I should be able to delete content
    And the content and all of it's sub content will be removed from the website

  Scenario: Reorder Children
    Given I am on the content admin page
    When I click on a root
    Then I should be able change the order of the root's children

  @javascript
  Scenario: Move Child to another Parent
    Given I am on the content admin page
    When I click on a root
    Then I should be able to move a child content to another parent
    And I should see the child listed within the other parent's children

