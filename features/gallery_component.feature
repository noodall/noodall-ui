@wip
Feature: Gallery Component
  To provide the ability to show many images on the website, website editors will be able
  to create a gallery of images within a template

  Background:
    Given I am signed in as a website editor

  @javascript
  Scenario: Gallery Module
    Given I am editing content
    When I click a "Wide" component slot
    And select the "Gallery" component
    And fill in the following within the component:
      | Title       | Big Promotion                     |
      | Description | A really big thing is happening!  |
    Then I add some images to from the asset library
    And I press "Save" within the component
    And I press "Publish"
    And I visit the content page
    Then I should see the gallery thumbnails
  
