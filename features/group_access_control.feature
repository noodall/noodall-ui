Feature: Groups access control
  To control which users will be able to modify certain parts of the website a website administrator will be able to set the access level that groups have to branches of the content tree

  Scenario: Set Content Permission
    Given I am signed in as a website administrator
    When I am editing content
    Then I should be able to set the permissions on that content

  Scenario Outline: Permissions
    Given content's <Permission> is set to "staff" and "students"
    Then only users in the "staff" and "students" should be able to <Actions> content
    And users not in the "staff" and "students" should not be able to <Actions> content

    Examples:
      | Permission | Actions                    |
      | Update     | Update, create children of |
      | Destroy    | Delete                     |
      | Publish    | Publish                    |

  Scenario: Inherited Permissions
    Given content exists with permissions set
    When a child of that content is created
    Then by default the child should have the same permissions as it's parent

  Scenario: Administrators
    Given I am signed in as a website administrator
    Then I should be able to carry out all actions regardless of group permissions
