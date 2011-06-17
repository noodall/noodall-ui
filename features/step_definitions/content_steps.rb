When /^I click on the primary navigation link "([^\"]*)"$/ do |arg1|
  visit root_path
  click_link_within 'ol#nav-node-tree-root', arg1
end

Given /^content exists within a branch of the content tree$/ do
  @_content = Factory(:page_a, :title => 'Top Page', :publish => true)
  3.times do |i|
    @_content = Factory(:page_a, :title => "Level #{i+1} Page", :parent => @_content, :publish => true)
  end
end

Then /^I should see a bread\-crumb trail available in the footer that details the content above that content in that branch$/ do
  page.should have_css( "div#breadcrumbs ul li", :count => 5 )
end

When /^I click any content title in the bread\-crumb$/ do
  click_link_within "div#breadcrumbs", "Level 2 Page"
end

Then /^I should be taken to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should be taken to that content$/ do
  within "#main-content h1" do |heading|
    heading.should contain "Level 2 Page"
  end
  have_css "div#breadcrumbs span", :count => 3
end

When /^the mouse hovers over a menu item a drop down should appear with 3 levels of the branch$/ do
  page.should have_css('ol#nav-node-tree-root li ol li ol li')
end


When /^I click on the secondary navigation link "([^\"]*)"$/ do |arg1|
  visit root_path

  click_link_within '#header .static-nav', arg1
end

Then /^I should be taken to the site map page$/ do
  URI.parse(current_url).path.should == sitemap_path
end


# Templates
Then /^I should see the current branch's tree menu$/ do
  page.should have_css('div#supporting-content ul#sub-page-nav')
end

# Then /^I should see (\d+) module areas$/ do |count|
#   page.should have_css('div.component', :count => count.to_i)
# end

Given /^a (?:root )?page exists using the "([^\"]*)" template$/ do |template_title|
  # mongo no understand! mongo sad :(
  Noodall::Node.all({:permalink => "that-#{template_title}-page"}).each{|n| n.destroy }

  template = template_title.downcase.gsub(' ','_')
  @_content = Factory(template.to_sym, :title => "That #{template_title} page")

  @_content.save
end

Given /^that page has (?:(?:(\d+) )?"([^\"]*)" )?subpages$/ do |count, template_title|

  template = template_title.downcase.gsub(' ','_') unless template_title.nil?

  (count || 5).to_i.times do
    Factory(( template.blank? ? :page_b : template.to_sym ), :parent => @_content, :publish => true)
  end
end

Given /^that page has an? (?:"([^\"]*)" )?parent$/ do |template_title|

  template = template_title.downcase.gsub(' ','_')

  @_content.parent = Factory(( template.blank? ? :page_b : template.to_sym ), :publish => true)
  @_content.save
end

Given /^that page has all available slots filled$/ do
  @_content.class.main_slots_count.to_i.times do |i|
    @_content.send("main_slot_#{i}=", Factory(:hero_panel))
  end

  @_content.class.wide_slots_count.to_i.times do |i|
    @_content.send("wide_slot_#{i}=", Factory(:gallery))
  end

  @_content.class.small_slots_count.to_i.times do |i|
    @_content.send("small_slot_#{i}=", Factory(:promo))
  end

  @_content.save
end




When /^I view a page that's content is in the "([^\"]*)" template and is not the branch root$/ do |template_title|
  template = template_title.downcase.gsub(' ','_')
  @_content = Factory(template.to_sym, :parent => Node.first, :publish => true)

  visit node_path(@_content)
end

When /^I view a page that's content is in the "([^\"]*)" template and is the branch root that does not have published children$/ do |template_title|
  template = template_title.downcase.gsub(' ','_')
  @_content = Factory(template.to_sym, :title => "a #{template_title} page",:publish => true)

  visit node_path(@_content)
end

When /^I view a page that's content is in the "([^\"]*)" template and it's parent is not the branch root that has published children$/ do |template_title|
  a_page = Factory(:page_a, :publish => true)
  b_page = Factory(:articles_list, :parent => a_page, :publish => true)

  template = template_title.downcase.gsub(' ','_')
  @_content = Factory(template.to_sym, :title => "a #{template_title} page", :parent => b_page, :publish => true)

  5.times do
    Factory(:page_a, :parent => b_page, :publish => true)
  end

  visit node_path(@_content)
end


Then /^I should not see the current branch's tree menu$/ do
  page.should_not have_css('div#supporting-content ul#sub-page-nav')
end


# Template Checks

Then /^the page should be in the (.+) template$/ do |template_name|
  # Check the correct template was rendered
  page.should have_css "body.#{template_name.gsub(/\W/, '').underscore}"
end

Then /^I should see (\d+) module areas$/ do |module_count|
  # Check the correct number of modules are in the model and the template
  curent_node = controller.instance_variable_get(:@node)

  curent_node.class.slots_count.should == module_count.to_i
end

When /^I view a page which is in the "([^\"]*)" template$/ do |template_title|
  template = template_title.downcase.gsub(' ','_')
  @_content = Factory(template.to_sym, :title => "a #{template_title} page", :publish => true)

  visit node_path(@_content)
end

Given /^that page contains articles$/ do
  5.times do
    Factory(:article_page, :parent => @_content, :publish => true)
  end
end

Then /^I should see a list of related content that is in the "([^\"]*)" template$/ do |arg1|
  # meh
end

When /^I click the RSS link$/ do
  click_link 'RSS'
end

Then /^I should get an RSS feed of sibling content that is in the "([^\"]*)" template$/ do |arg1|
  page.should have_css('rss channel')
end

Given /^that page has a parent list$/ do
  parent = Factory(:articles_list, :title => "an article list page", :publish => true)
  @_content.parent =parent
  @_content.save
end

Then /^I should see the course information box$/ do
  within("#course-info") do |course_info|
    course_info.should contain('Mr Spoon')
    course_info.should contain('AB1234')
  end
end


Given /^a content branch has the follow nodes$/ do |table|
  @_content = Factory(:page_a, :title => 'Top Page', :publish => true)
  table.hashes.each do |row|
    @_subcontent = Factory(:page_a, :title => row['title'], :parent => @_content, :publish => true)
  end
end