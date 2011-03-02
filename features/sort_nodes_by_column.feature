Feature: Sort nodes by column
  As a website admin
  In order to peruse nodes more effectively
  I want to be able to order them by their various column titles

  Scenario Outline: 
    Given some nodes exist
    When I am on the content admin page
    And I follow <Title>
    Then the nodes should be ordered by <Title>
    
    Examples:
    | Title      |
    | "Title"    |
    | "Type"     |
    | "Updated"  |
