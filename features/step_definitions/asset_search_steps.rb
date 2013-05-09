Given /^there are assets that can be searched$/ do
  step %q{the website has been populated with content based on the site map}
  3.times do |i|
    Factory(:asset, :title => "My Searchable Asset #{i}")
  end
end

Given /^I enter a search term in the asset search input$/ do
  visit noodall_admin_assets_path
  fill_in 'Search', :with => 'Searchable'
end

Then /^I should see a paginated list of assets that matches my search term ordered by relevance$/ do
  page.should have_css('dl#search-results dt', :count => 3)
  within("dl#search-results dt:first") { click_link "My Searchable Asset 1" }
end
