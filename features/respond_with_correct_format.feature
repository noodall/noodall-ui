Feature: Respond with the correct format
  In order that the developers can add node views in different formats viewing a node should render a registered format if a template for it exists

  Scenario: Render correct format
    Given a page a exists with a title of "My Formatted Page"
    When I view the page "My Formatted Page" as "html"
    Then show me the page
    Then I should see "My Formatted Page"
    When I view the page "My Formatted Page" as "rss"
    Then I should see "My Formatted Page"
    When I view the page "My Formatted Page" as "xml"
    Then I should see "The page you were looking for doesn't exist"

