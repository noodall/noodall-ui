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
  response.should have_css( "div#breadcrumbs ul li", :count => 5 )
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
  response.should have_css('ol#nav-node-tree-root li ol li ol li')
end


When /^I click on the secondary navigation link "([^\"]*)"$/ do |arg1|
  visit root_path

  click_link_within '#header .static-nav', arg1
end

Then /^I should be taken to the site map page$/ do
  URI.parse(current_url).path.should == sitemap_path
end

# Language Driver

Given /^the content titled "([^\"]*)" has the child content "([^\"]*)", "([^\"]*)" and "([^\"]*)"$/ do |content, child1, child2, child3|
  @_content = Factory(:page_a, :title => content, :permalink => "study/international-students/about-the-college", :publish => true)
  [child1, child2, child3].each do |lang|
    Factory(:page_a, :title => lang, :parent => @_content, :publish => true)
  end
end

Then /^I should see the language select element$/ do
  visit root_path
  response.should have_css("li.lang a", :count => 3)
end

When /^I select "([^\"]*)" from the language select element$/ do |lang|
  click_link_within("li.lang", lang)
end

# Course Driver
Given /^"([^\"]*)" content exists within the Foundation, Undergraduate and Postgraduate Courses branches of the content tree$/ do |arg1|
  ['Training Courses', 'Undergraduate Study', 'Postgraduate Study'].each do |title|
    node = Node.find_by_title(title)
    5.times do |i|
      Factory(:study_landing_page, :title => "#{title} School #{i+1}", :publish => true, :parent => node)
    end
    3.times do
      Factory(:page_a, :publish => true, :parent => node)
    end
  end
end

Then /^I should see a course select element for Foundation, Undergraduate and Postgraduate Courses$/ do
  within "div#course-driver" do |driver|
    ['Training Courses', 'Undergraduate Study', 'Postgraduate Study'].each do |title|
      driver.should contain(title)
    end
  end
end

Then /^each course select element should contain the titles of content in "([^\"]*)" template in that branch$/ do |arg1|
  within "div#course-driver" do |driver|
    ['Training Courses', 'Undergraduate Study', 'Postgraduate Study'].each do |title|
      driver.should have_css("ul#study-#{title.parameterize}-courses li", :count => 6) # 6 as Scott has added the "Choose" li
    end
  end
end

When /^select a course name from course select element$/ do
  @_content = Node.find_by_title('Training Courses').children.first
  click_link_within "div#course-driver", @_content.title
end


# Templates
Then /^I should see the current branch's tree menu$/ do
  response.should have_css('div#supporting-content ul#sub-page-nav')
end

# Then /^I should see (\d+) module areas$/ do |count|
#   response.should have_css('div.component', :count => count.to_i)
# end

Given /^a (?:root )?page exists using the "([^\"]*)" template$/ do |template_title|
  # mongo no understand! mongo sad :(
  Node.all({:permalink => "that-#{template_title}-page"}).each{|n| n.destroy }

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
  response.should_not have_css('div#supporting-content ul#sub-page-nav')
end


# Template Checks

Then /^the page should be in the (.+) template$/ do |template_name|
  # Check the correct template was rendered
  response.should have_css "body.#{template_name.gsub(/\W/, '').underscore}"
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
  response.should have_css('rss channel')
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
