Then /^I should be able to set the permissions on that content$/ do
  fill_in "Update", :with => "Them, Us, Things"
  fill_in "Delete", :with => "Us, Things, Stuff"
  fill_in "Publish", :with => "Us, Stuff"
  click_button "Publish"
  @_content.reload
  @_content.updatable_groups.should == ['Them', 'Us', 'Things']
  @_content.destroyable_groups.should == ['Us', 'Things', 'Stuff']
  @_content.publishable_groups.should == ['Us', 'Stuff']
end

Given(/^content's ([^\"]*) is set to "([^\"]*)" and "([^\"]*)"$/) do |permission, group1, group2|
  @_content = Factory(:page_a, "#{permission.downcase.gsub(/e$/,'')}able_groups" => [group1, group2], :hide => true)
end

Then(/^only users in the "([^\"]*)" and "([^\"]*)" should be able to ([^\"]*) content$/) do |group1, group2, actions|
  [group1, group2].each do |group|
    Given %{I am signed in as a #{group}}
    actions.split(', ').each do |action|
      case action
      when "Update"
        visit admin_node_path(@_content)
        click_button "Draft"
      when "create children of"
        visit admin_node_nodes_path(@_content)
        click_link_within ".choices", "New"
        click_button "Create"
      when "Delete"
        visit admin_nodes_path
        click_link_within "tr:contains('#{@_content.title}')", "Delete"
        # REcreate for the next run
        @_content = Factory(:page_a, "destroyable_groups" => [group1, group2])
      when "Publish"
        visit admin_node_path(@_content)
        begin
          click_button "Publish"
        rescue Webrat::NotFoundError => e
          raise Canable::Transgression # Raise this if we can't find the button
        end
      end
    end
    Then %{I sign out} #Neeed to do this or remeber cookie gets in the way
  end
end

Then(/^users not in the "([^\"]*)" and "([^\"]*)" should not be able to ([^\"]*) content$/) do |group1, group2, action|
  lambda { Then %{only users in the "nongroup" and "anothergroup" should be able to #{action} content} }.should raise_error(Canable::Transgression)
end

Given /^content exists with permissions set$/ do
  @_content = Factory(:page_a, :updatable_groups => ['Dudes'], :destroyable_groups => ['Webbies', 'Dudes'], :publishable_groups => ['Dudes'] )
end

When /^a child of that content is created$/ do
  Given %{I am signed in as a website administrator}
  visit admin_node_nodes_path(@_content)
  click_link_within ".choices", "New"
  fill_in "Title", :with => "Permeable Content"
  choose("Page A")
  click_button "Create"
end

Then(/^by default the child should have the same permissions as it's parent$/) do
  response.should have_css("input#node_updatable_groups_list") do |input|
    input.should have_xpath("@value") do |value|
      value.should contain("Dudes")
    end
  end
  response.should have_css("input#node_destroyable_groups_list") do |input|
    input.should have_xpath("@value") do |value|
      value.should contain("Webbies, Dudes")
    end
  end
  response.should have_css("input#node_publishable_groups_list") do |input|
    input.should have_xpath("@value") do |value|
      value.should contain("Dudes")
    end
  end
end

Then /^I should be able to carry out all actions regardless of group permissions$/ do
  Given %{content exists with permissions set}
  visit admin_node_path(@_content)
  click_button "Draft"
  visit admin_node_nodes_path(@_content)
  click_link_within ".choices", "New"
  click_button "Create"
  visit admin_node_path(@_content)
  click_button "Publish"
  visit admin_nodes_path
  click_link_within "tr:contains('#{@_content.title}')", "Delete"
end
