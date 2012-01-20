Given /^I make some changes$/ do
  fill_in 'Title', :with => 'A new version'
end

Then /^the live page should be at version (\d+)$/ do |version|
  @_content = Noodall::Node.find(@_content.id) # Reload the model to remove memoized versions (reload does not do this)
  visit node_path(@_content)
  version = @_content.version_at(version.to_i)
  page.should have_content(version.content(:title))
end

Then /^the form should contain version (\d+)$/ do |version|
  @_content = Noodall::Node.find(@_content.id) # Reload the model to remove memoized versions (reload does not do this)
  version = @_content.version_at(version.to_i)
  step %{the "Title" field should contain "#{version.content(:title)}"}
end

Then /^I should see a list of previous versions$/ do
  page.should have_css("table#versions-list tr", :count => @_content.all_versions.count)
end

When /^I follow "([^"]*)" within version (\d+)$/ do |link_name, version_number|
  within "tr:contains('Version #{version_number}')" do
    click_link link_name
  end
end

Given /^content exists with several versions$/ do
  @_content = Factory(:page_a)
  3.times do |i|
    @_content.title = "Title #{i}"
    @_content.save
  end
end

Then /^I should see version (\d+) of the content$/ do |version|
  version = @_content.version_at(version.to_i)
  page.should have_content(version.content(:title))
end
