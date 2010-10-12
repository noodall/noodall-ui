Feature: Content Components
  In order to allow flexibility within the templates a website user will be able to add predefined component that provide specific functionality to predefined areas within a template

  Scenario: Select a Component
    Given I am signed in as a website editor
    And I am editing content
    When I select a component slot
    Then I should be able to set the component and its content
