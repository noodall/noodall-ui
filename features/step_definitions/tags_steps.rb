Then /^I should see the tags list$/ do
  page.should have_content('stuff, things, what, eh')
end

When /^I follow "([^"]*)" within the tag list$/ do |tag|
  within 'span.tags' do
    click_link tag
  end
end
