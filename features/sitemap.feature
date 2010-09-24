@website
Feature: SITE MAP
  In order to allow website visitors to see on overview of the entire site the website will
  provide a site map showing all content on the website

  Scenario: View Site Map
    Given the website has been populated with content based on the site map
    When I am on the site map page
    Then I should see a tree style list that contains all content that is not in the "ArticlePage" template
