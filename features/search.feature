Feature: Search
  To allow website visitors to easily find content the website will have a keyword search facility that searches all content on the site

  Background:
    Given there is content that can be searched

  Scenario: Search
    Given I enter a search term in the search input
    And press "Search"
    Then I should see a paginated list of content that matches my search term ordered by relevance


