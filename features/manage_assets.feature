Feature: Manage assets
In order to allow easy access to documents whilst editing a website editor will be able to easily upload, browse and modify documents

  Scenario: Upload an Asset
    Given I am using the asset library
    When I upload a file
    And enter tags
    Then it should appear in the asset library

  Scenario: Browse Assets
    Given files have been uploaded to the asset library
    When I am using the asset library
    Then I should be able to browse assets by content type
    And I should be able to browse assets by tags
# TODO: Use someting to test this JS
@wip
  Scenario: Insert an asset
    When I am editing content
    And I click insert a file
    And select a file from the asset library
    Then the asset should appear in the content editor

