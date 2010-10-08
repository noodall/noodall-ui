Given /^the website has been populated with content based on the site map$/ do
  seed_file = File.join(Rails.root, "demo", "seeds.rb")
  load(seed_file)
end

When /^I click on a root$/ do
  @_page = Noodall::Node.roots.last
  within("tr:last") { click_link "Children" } 
end

Then /^I should see a list the of the root’s children$/ do
  @_page.children.each do |child|
    page.should have_content(child.title)
  end
end

When /^I click on a child$/ do
  @_child = @_page.children.first
  within(:css, "tr:first") { click_link "Children" }
end

Then /^I should see a list of the child’s children$/ do
  @_child.children.each do |gchild|
    page.should have_content(gchild.title)
  end
end

Then /^I should be able to create a new root$/ do
  click_link 'New'

  fill_in 'Title', :with => 'New Root'

  click_button 'Create'

  page.should have_content(' was successfully created.')
end

Then /^I should see the root listed within the roots$/ do
  visit noodall_admin_nodes_path
  page.should have_content('New Root')
end

Then /^I should be able to create a new child$/ do
  click_link 'New'

  fill_in 'Title', :with => 'New Child'

  click_button 'Create'

  page.should have_content(' was successfully created.')
end

Then /^I should see the child listed within the root’s children$/ do
  visit noodall_admin_node_nodes_path(@_page)
  page.should have_content('New Child')
end

Then /^I should be able to delete content$/ do
  @_deleted_node = Noodall::Node.roots.last
  @_deleted_node_children = @_deleted_node.children

  within(:css, 'table tbody tr:last') { click_link "Delete" }
  page.should have_content("deleted")
end

Then /^the content and all of it’s sub content will be removed from the website$/ do
 
  lambda { visit node_path(@_deleted_node) }.should raise_error(MongoMapper::DocumentNotFound)

  @_deleted_node_children.each do |child|
    lambda { visit node_path(child) }.should raise_error(MongoMapper::DocumentNotFound)
  end
end

Then /^I should be able to move a child content to another parent$/ do
  @_child = @_page.children.first
  @_new_parent = Noodall::Node.roots.first
  within(:css, "table tbody tr#node-#{@_child.id}") { click_link "Edit" }
  # Simulates what we are now doing with JS
  click_link "Advanced"
  within(:css, '#parent-title' ) { click_link "Edit" }
  within(:css, 'ol.tree' ) { click_link @_new_parent.title }
  click_button 'Draft'
end

Then /^I should see the child listed within the other parent’s children$/ do
  visit noodall_admin_node_nodes_path(@_new_parent)
  within('tbody') do 
    page.should have_content(@_child.title)
  end
end

Then /^I should be able change the order of the root’s children$/ do
  table = table(tableish("table tr", 'td, th'))
  title = table.hashes[2]['Title'] # 2 as zero index
  within(:css, 'table tbody tr:nth(3)') { click_link "up" }
  table = table(tableish("table tr", 'td, th'))
  table.hashes[1]['Title'].should == title
  within(:css, 'table tbody tr:nth(2)' ) { click_link "down" }
  within(:css, 'table tbody tr:nth(3)' ) { click_link "down" }
  table = table(tableish("table tr", 'td, th'))
  table.hashes[3]['Title'].should == title
end

When /^I create a new child under an ancestor in "([^"]+)" template$/ do |template_title|
  template = template_title.downcase.gsub(' ','_')
  #create the ancester
  parent = Factory(template.to_sym)

  visit noodall_admin_node_nodes_path(parent)
  click_link 'New'
end

Then /^I should be able select a template from the "([^"]+)"$/ do |sub_template_string|
  sub_templates = sub_template_string.split(', ')

  sub_templates.each do |sub_template|
    choose sub_template
  end
end

Then /^I should see a list of the roots$/ do
  Noodall::Node.roots.each do |root|
    page.should have_content(root.title)
  end
end
