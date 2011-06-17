Feature: Filter Branch
  In order to easily find content in branches with lots of content
  a website editor
  will be able to filter by title key word

  Scenario: Filter Branch
    Given a content branch has the follow nodes
      | title           |
      | home            |
      | home and away   |
      | neighbours      |
      | australia       |
      | home sweet home |
    And I go to that page in the CMS
    And I fill in "Filter by Title" with "Home"
    And press "Filter"
    Then I should see 3 nodes
    And I fill in "Filter by Title" with "australia"
    And press "Filter"    
    Then I should see 1 node