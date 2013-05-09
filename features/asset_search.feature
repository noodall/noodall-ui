Feature: Search
  To allow website visitors to easily find assets the website will have a keyword search facility that searches all content on the site

  Background:
    Given there are assets that can be searched

  Scenario: Search
    Given I enter a search term in the asset search input
    And press "Search"
    Then I should see a paginated list of assets that matches my search term ordered by relevance


