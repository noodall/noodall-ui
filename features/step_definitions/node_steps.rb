Given /^content exists$/ do
  @_content = Factory(:page_a)
end

When /^I create a new root$/ do
  visit new_noodall_admin_node_path
end

Then /^I should be able select a template from the following:$/ do |table|
  table.hashes.each do |row|
    visit new_noodall_admin_node_path
    choose(row['Template'])
    fill_in("Title", :with => "A title")
    click_button "Create"
    page.should have_content "#{row['Template']} 'A title' was successfully created."
  end
end

Then /^I should see a tree style list that contains all content$/ do
  #Roots
  page.should have_css("ol#sitemap-node-tree-root li:nth(#{Noodall::Node.roots.count})")

  page.should have_css("ol#sitemap-node-tree-root li li")

end


Then /^I should see a page of xml$/ do
  save_and_open_page
  page.should have_xpath("//urlset")
end