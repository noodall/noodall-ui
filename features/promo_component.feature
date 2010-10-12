Feature: Promo Component
  In order to promotional information on a page a website editor will be able
  to add text and image content wthin component slots

  @javascript
  Scenario: Add a promo component
    Given I am signed in as a website editor
    And I am editing content
    When I click a "Small" component slot
    And select the "Promo" component
    And fill in the following within the component:
      | Title       | Big Promotion                     |
      | Description | A really big thing is happening!  |
      | Link        | http://wearebeef.co.uk            |
    And I press "Save" within the component
    And I press "Publish"
    And I visit the content page
    Then I should see "Big Promotion" 
