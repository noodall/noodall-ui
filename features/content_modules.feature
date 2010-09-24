Feature: CONTENT MODULES
  In order to allow flexibility within the templates a website user will be able to add predefined modules that provide specific functionality to predefined areas within a template

  Scenario: Select a Module
    Given I am signed in as a website editor
    And I am editing content
    When I select a module area
    Then I should be able to set the module and its content
