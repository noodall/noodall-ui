When /^today is "([^\"]*)"$/ do |date|
  Time.stub!(:now).and_return(date.to_time)
end

When(/^I publish the content$/) do
  visit admin_node_path(@_content)
  click_button('publish')
end

When(/^I save content as draft$/) do
  visit admin_node_path(@_content)
  click_button('draft')
end

Then(/^the content should (not |)be visible on the website$/) do |is_not|
  if is_not.blank?
    visit node_path(@_content)
    response.should be_success
  else
    lambda { visit node_path(@_content) }.should raise_error(MongoMapper::DocumentNotFound)
  end
end

Given(/^I publish content between "([^\"]*)" and "([^\"]*)"$/) do |from, to|
  visit admin_node_path(@_content), :get, :published_at => true, :published_to => true
  select_datetime(from.to_time, :from => 'Publish at')
  select_datetime(to.to_time, :from => 'Publish until')
  click_button('Publish')
  response.should contain(/was successfully updated/)
end


Given /^published content exists with publish to date: "([^\"]*)"$/ do |time|
  time = time.to_time
  @_content = Factory(:page_a, :published_at => time.yesterday, :published_to => time)
end

When /^I am editing the content$/ do
  visit admin_node_path(@_content)
end

When /^I clear the publish to date$/ do
  5.times{ |i|   select("", :from => "node[published_to(#{i+1}i)]" ) }
  click_button 'Publish'
end