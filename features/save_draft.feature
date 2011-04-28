Feature: Work with drafts
  In order on a new new version of content without publishing
  A website editor
  Will be able to save a draft

  Scenario: Save a draft
    Given I am editing content
    And I make some changes
    And I press "Draft"
    Then I should see "was successfully saved as version 1 (draft)"
    And the live page should be at version 0
    When I go to edit the content again
    Then I should see "You are editing a draft version of this page"
    And the form should contain version 1

    Given I go to edit the content again
    And I press "Publish"
    Then I should see "was successfully published"
    Then the live page should be at version 2

    Given I go to edit the content again
    And I follow "Versions"
    Then I should see a list of previous versions
    When I follow "Use" within version 1
    Then the form should contain version 1
    When I press "Publish"
    Then the live page should be at version 1
