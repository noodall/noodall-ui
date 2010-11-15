Feature: Content Templates
  In order to change how the content looks and acts on the website a website editor will be able to select from predetermined templates

  Scenario: Create Root Content
    Given I create a new root
    Then I should be able select a template from the following:
     | Template           |
     | Page A             |
     | Page C             |

  Scenario Outline: Create Child Content
    Given I create a new child under an ancestor in "<Ancestor Template Name>" template
    Then I should be able select a template from the "<Allowed Templates>"

    Examples:
     | Ancestor Template Name | Allowed Templates       |
     | Page A                 | Page A, Page B, Page C  |
     | Page C                 | Page B                  |
