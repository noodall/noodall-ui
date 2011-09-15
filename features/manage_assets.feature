Feature: Manage assets
In order to allow easy access to documents whilst editing a website editor will be able to easily upload, browse and modify documents

  Scenario: Upload an Asset
    Given I am using the asset library
    When I upload a file
    And enter tags
    Then it should appear in the asset library
    When I follow "Show"
    Then I should see "Viewing"
    When I follow "Edit"
    Then I should see "Editing Asset"

  Scenario: Browse Assets
    Given files have been uploaded to the asset library
    When I am using the asset library
    Then I should be able to browse assets by content type
    And I should be able to browse assets by tags

  @javascript
  Scenario: Insert an asset
    Given files have been uploaded to the asset library
    When I am editing content
    And I click the editor "Insert Asset" button
    And follow "Images"
    And I click "Add" on an Asset
    And I click on the small icon
    Then the "Image" asset should appear in the content editor

  Scenario: Handle no assets when visiting assets pending
    Given there are no assets
    When I visit the admin assets pending
    Then I should be redirected to the admin assets page
      And I should see the message "No assets pending"