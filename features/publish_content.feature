Feature: Publish Content
In order to control when content is available on the website a website administrator will be able to define the time period for which content is published

  Scenario: Publish content
    Given content exists
    When I publish the content
    Then the content should be visible on the website
    When I hide the content
    Then the content should not be visible on the website

  Scenario: Publish content for set period
    Given content exists
    And I publish content between "20th July 2010" and "30th July 2010"
    And today is "15th July 2010"
    Then the content should not be visible on the website
    When today is "25th July 2010"
    Then the content should be visible on the website
    When today is "5th August 2010"
    Then the content should not be visible on the website

  @wip
  Scenario: Publish content for set period
    Given today is "5th August 2010"
    And published content exists with publish to date: "30th July 2010"
    Then the content should not be visible on the website
    When I am editing the content
    And I clear the publish to date
    Then the content should be visible on the website

