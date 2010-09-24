@website
Feature: Content
  In order to easily find content that gives them the information they need a website visitor will be able to easily navigate through the tree structure of the website

  Background:
    Given the website has been populated with content based on the site map

  Scenario Outline: Primary Navigation
    When I click on the primary navigation link "<Link Name>"
    Then I should be taken to the <Link Destination> page
    When the mouse hovers over a menu item a drop down should appear with 3 levels of the branch
    Examples:
    | Link Name                    | Link Destination                                  |
    | Home                         | root content titled "Home"                        |

  Scenario: Bread-crumb trail
    Given content exists within a branch of the content tree
    When I visit the content page
    Then I should see a bread-crumb trail available in the footer that details the content above that content in that branch
    When I click any content title in the bread-crumb
    Then I should be taken to that content

  Scenario Outline: Secondary Navigation
    When I click on the secondary navigation link "<Link Name>"
    Then I should be taken to the <Link Destination> page

    Examples:
    | Link Name  | Link Destination                 |
    | Site Map   | site map                         |
    | Contact Us | root content titled "Contact Us" |
