Given /^content exists$/ do
  @_content = Factory(:page_a)
end

When /^I create a new root$/ do
  visit new_admin_node_path
end

Then /^I should be able select a template from the following:$/ do |table|
  table.hashes.each do |row|
    visit new_admin_node_path
    choose(row['Template'])
    fill_in("Title", :with => "A title")
    click_button "Create"
    response.should contain "#{row['Template']} 'A title' was successfully created."
  end
end


Then /^I should see a tree style list that contains all content that is not in the "([^\"]+)" template$/ do |arg1|
  ['The College', 'Student Life', 'Alumni', 'Research & Consultancy', 'Business Services', 'Conferences & Events', 'Jobs'].each do |title|
    response.should have_selector("ol#sitemap-node-tree-root li:contains(\"#{title}\")")
  end

  parent = PageA.find_by_title('The College')
  ['Virtual Tour', 'History & Heritage', 'Principal\'s Message', 'Locations', 'Staff Profiles', 'RAC in the community', 'Governance & finance'].each do |title|
    response.should have_selector("ol#sitemap-node-tree-#{parent.id.to_s} li:contains(\"#{title}\")")
  end

  ['Study'].each do |title|
    response.should have_selector("ol#sitemap-node-tree-root li:contains(\"#{title}\")")
  end
end
