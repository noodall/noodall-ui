Feature: Work with drafts
  In order on a new new version of content without publishing
  A website editor
  Will be able to save a draft

  Scenario: Save a draft
    Given I am editing content
    And I make some changes
    And I press "Draft"
    Then show me the page
    Then I should see "was successfully saved as version 1 (draft)"
    And the live page should be at version 0
    When I go to edit the content again
    Then I should see "You are editing a draft version of this page"
    And the form should contain version 1

    Given I go to edit the content again
    When I publish the content
    Then I should see "has been successfully published"
    Then the live page should be at version 2

    Given I go to edit the content again
    And I press "Versions"
    Then I should see a list of previous versions
    When I press "Use" within version 1
    Then I should be editing version 1
    When I press "publish"
    Then the live page should be at version 1
