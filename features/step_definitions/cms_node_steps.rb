Given /^the website has been populated with content based on the site map$/ do
  seed_file = File.join(Rails.root, "db", "seeds.rb")
  load(seed_file)
end

When /^I click on a root$/ do
  @_page = Node.find_by_permalink('study') # Becuase we know it has children
  click_link_within "tr:contains('#{@_page.title}')", /\d Child/
end

Then /^I should see a list the of the root’s children$/ do
  @_page.children.each do |child|
    response.should contain(child.title)
  end
end

When /^I click on a child$/ do
  @_child = @_page.children.first
  click_link_within "tr:contains('#{@_child.title}')", /\d Child/
end

Then /^I should see a list of the child’s children$/ do
  @_grandchild = @_child.children

  @_grandchild.each do |gchild|
    response.should contain(gchild.title)
  end
end

Then /^I should be able to create a new root$/ do
  click_link 'New'

  fill_in :title, :with => 'New Root'

  click_button 'Create'

  response.should contain(' was successfully created.')
end

Then /^I should see the root listed within the roots$/ do
  visit admin_nodes_path
  response.should contain('New Root')
end

Then /^I should be able to create a new child$/ do
  click_link 'New'

  fill_in :title, :with => 'New Child'

  click_button 'Create'

  response.should contain(' was successfully created.')
end

Then /^I should see the child listed within the root’s children$/ do
  visit admin_node_nodes_path(@_page)
  response.should contain('New Child')
end

Then /^I should be able to delete content$/ do
  response.should have_css('table tbody tr:nth(3) td') do |cells|
    @deleted_content = cells.first.content
  end

  @_deleted_node = Node.find_by_title(@deleted_content)
  @_deleted_node_children = @_deleted_node.children

  click_link_within('table tbody tr:nth(3)', /delete/i)
  response.should contain("deleted")
end

Then /^the content and all of it’s sub content will be removed from the website$/ do

  lambda { visit node_path(@_deleted_node) }.should raise_error(MongoMapper::DocumentNotFound)

  @_deleted_node_children.each do |child|
    lambda { visit node_path(child) }.should raise_error(MongoMapper::DocumentNotFound)
  end
end

Then /^I should be able to move a child content to another parent$/ do
  @_child = @_page.children.first
  click_link_within("table tbody tr#node-#{@_child.id}", /edit/i)
  # Simulates what we are now doing with JS
  set_hidden_field 'node_parent', :to => @_page.children[2].id
  click_button 'Draft'
end

Then /^I should see the child listed within the other parent’s children$/ do
  visit admin_node_nodes_path(@_page.children[1].id)
  within('tbody') do |table_body|
    table_body.should contain(@_child.title)
  end
end

Then /^I should be able change the order of the root’s children$/ do
  table = table(tableish("table tr", 'td, th'))
  title = table.hashes[2]['Title'] # 2 as zero index
  click_link_within('table tbody tr:nth(3)', /up/i)
  table = table(tableish("table tr", 'td, th'))
  table.hashes[1]['Title'].should == title
  click_link_within('table tbody tr:nth(2)', /down/i)
  click_link_within('table tbody tr:nth(3)', /down/i)
  table = table(tableish("table tr", 'td, th'))
  table.hashes[3]['Title'].should == title
end

When /^I create a new child under an ancestor in "([^"]+)" template$/ do |template_title|
  template = template_title.downcase.gsub(' ','_')
  #create the ancester
  parent = Factory(template.to_sym)

  visit admin_node_nodes_path(parent)
  click_link 'New'
end

Then /^I should be able select a template from the "([^"]+)"$/ do |sub_template_string|
  sub_templates = sub_template_string.split(', ')

  sub_templates.each do |sub_template|
    choose sub_template
  end
end

Then /^I should see a list of the roots$/ do
  Node.roots.each do |root|
    response.should contain(root.title)
  end
end
