@website
Feature: Site Map
  In order to allow website visitors to see on overview of the entire site the website will
  provide a site map showing all content on the website

  Scenario: View Site Map
    Given the website has been populated with content based on the site map
    When I am on the site map page
    Then I should see a tree style list that contains all content

  Scenario: View Site Map XML
    Given the website has been populated with content based on the site map
    When I am on the site map xml page
    Then I should see a page of xml
