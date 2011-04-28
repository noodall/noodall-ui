Given /^I make some changes$/ do
  fill_in 'Title', :with => 'A new version'
end

Then /^the live page should be at version (\d+)$/ do |version|
  visit node_path(@_content)
  version = @_content.version_at(version.to_i)
  page.should have_content(version.content(:title))
end

Given /^I edit the content again$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a list of previous versions$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I press "([^"]*)" within version (\d+)$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be editing version (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

