When /^I click preview$/ do
  click_link 'Preview'
end

Then /^I should see how the content will look in the website$/ do
  page.should have_css('div#preview-pane')
end
