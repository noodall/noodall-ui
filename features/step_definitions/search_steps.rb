Given /^there is content that can be searched$/ do
  step %q{the website has been populated with content based on the site map}
  3.times do |i|
    Factory(:page_a, :title => "My Searchable Page #{i}", :publish => true)
  end
  top_hit = Factory(:page_a, :title => "My Extra Searchable Page", :description => "My Extra Searchable Page", :publish => true)
  3.times do |i|
    Factory(:page_a, :title => "My Unfit Page #{i}", :publish => true)
  end
end

Given /^I enter a search term in the search input$/ do
  visit root_path
  fill_in 'q', :with => 'Searchable'
end

Then /^I should see a paginated list of content that matches my search term ordered by relevance$/ do
  # save_and_open_page
  page.should have_css('dl#search-results dt', :count => 4)
  within("dl#search-results dt:first") { click_link "My Extra Searchable Page" }
end
