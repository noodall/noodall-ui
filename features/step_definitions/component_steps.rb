Given /^I am editing content$/ do
  @_content = Factory(:page_a)
  visit noodall_admin_node_path(@_content)
end

When /^(?:|I )click a "([^"]*)" component slot$/ do |slot_name|
  within('ol#slot-list') do
    click_link "#{slot_name} Slot"
  end
end

When /^(?:|I )select the "([^\"]+)" component$/ do |component_name|
  within "#fancybox-inner" do
    select component_name, :from => 'Select the type of component'
  end
end

When /^(?:|I )fill in the following within the component:$/ do |fields|
  within "#fancybox-inner" do
    fields.rows_hash.each do |name, value|
      When %{I fill in "#{name}" with "#{value}"}
    end 
  end
end

When /^(?:|I )press "([^"]*)" within the component$/ do |button|
  within "#fancybox-inner" do
    click_button(button)
  end
end

When /^(?:|I )select an image from the asset library$/ do
  asset = Factory(:asset, :title => "My Image")
  within "#fancybox-inner" do
    pending
  end
end

When /^(?:I|a website visitor) visit(?:s|) the content page$/ do
  visit node_path(@_content)
end


Then /^I should see the general content$/ do
  within("div##{@_slot_type}_slot_0.general-content") do |slot|
    slot.should contain('Test Title One')
  end
end

Then /^I select an image from the asset library$/ do
  within "li.multi-file:last" do
    asset = Factory(:asset, :title => "Image 1")
    set_hidden_field "node[#{@_slot_type}_slot_0][contents][][asset_id]", :to => asset.id
  end
end

Then /^I enter an image title \(optional\)$/ do
  within "li.multi-file:last" do
    fill_in "node[#{@_slot_type}_slot_0][contents][][title]", :with => 'Image 1'
  end
end

Then /^I enter an image description \(optional\)$/ do
  within "li.multi-file:last" do
    fill_in "node[#{@_slot_type}_slot_0][contents][][body]", :with => 'The First Image'
  end
end

Then /^I enter an image URL \(optional\)$/ do
  within "li.multi-file:last" do
    fill_in "node[#{@_slot_type}_slot_0][contents][][url]", :with => 'http://www.google.com'
  end
end


Then /^I set a link target window \(optional\)$/ do
  within "li.multi-file:last" do
    select "New Window", :from => "node[#{@_slot_type}_slot_0][contents][][target]"
  end
end

Given /^I create a gallery in a (wide|small) slot$/ do |slot_type|
  Given %q{I am editing content}
  @_slot_type = slot_type
  within("div.#{@_slot_type}-slot") do |form|
    form.select "Gallery", :from => 'Select the type of component'
  end
  @_content.send("#{@_slot_type}_slot_0=", Factory(:gallery))
  @_content.save!
  # Reopen page so we can fill in the the form
  visit admin_node_path(@_content)
end

Then /^I should be able to select the gallery style from "widget" and "list"$/ do
  within("#wide_component_form_0 select#node_wide_slot_0_style") do |select|
    select.should contain('widget')
    select.should contain('list')
  end
end

Then /^I should not be able to select the gallery style$/ do
  response.should_not have_selector("#small_component_form_0 select#node_small_slot_0_style")
end

Given /^I create content with a gallery set to "([^\"]*)" style$/ do |style|
  @_content = Factory(:page_a)
  @_content.send("wide_slot_0=", Factory(:gallery, :style => style))
  @_content.save!
  @_slot_type = "wide"
  # Reopen page so we can fill in the the form
  visit node_path(@_content)
end


Then /^I should see the gallery thumbnails in a widget$/ do
  response.should have_selector("ul.gallery.widget li img", :count => 5)
end

Then /^I should see all the gallery thumbnails$/ do
  response.should have_selector("ul.gallery.list li img", :count => 5)
end

Then /^I enter the same for more images$/ do
  click_button "Publish"
  visit admin_node_path(@_content)
  3.times do |i|
    within "li.multi-file:last" do
      asset = Factory(:asset)
      set_hidden_field "node[#{@_slot_type}_slot_0][contents][][asset_id]", :to => asset.id
      fill_in "node[#{@_slot_type}_slot_0][contents][][title]", :with => "Image #{i+2}"
      fill_in "node[#{@_slot_type}_slot_0][contents][][body]", :with => "The Image number #{i+2}"
      fill_in "node[#{@_slot_type}_slot_0][contents][][url]", :with => 'http://www.google.com'
    end
    click_button "Publish"
    visit admin_node_path(@_content)
  end
end

Then /^I should see the (gallery thumbnails|slideshow)$/ do |type|
  @_content.reload
  @_content.send("#{@_slot_type}_slot_0").contents.should have(9).things
  case type
  when "gallery thumbnails"
    response.should have_selector("ul.gallery li img", :count => 9)
  when "slideshow"
    class_name = ""
    response.should have_selector("dl.hero-panel dt img", :count => 9)
  end
end


Given /^content exists with a gallery$/ do
  @_content = Factory(:page_a)
  @_content.small_slot_0 = Factory(:gallery)
  @_content.save
end

Given /^I have not entered a URL for the first image$/ do
  @_content.small_slot_0.contents.first.url = ''
  @_content.save
end

Given /^I have entered a URL for the second image$/ do
  @_content.small_slot_0.contents[1].url = 'http://example.com'
  @_content.save
end

When /^I click on the first image$/ do
  @_image = @_content.small_slot_0.contents.first
  click_link_within("ul.gallery li:first", @_image.title)
end

Then /^I should see a larger version of the image$/ do
  # taadaa
end

When /^I click on the second image$/ do
  @_image = @_content.small_slot_0.contents[1]
  response.should have_selector("ul.gallery li:nth(2) a[href='#{@_image.url}']")
end
#
Then /^I should be taken to the URL location$/ do
  # Link already checked
end

Then /^I select some files from the asset library$/ do
  3.times do |i|
    within "li.multi-file:last" do
      asset = Factory(:document_asset, :title => "Download #{i+1}")
      set_hidden_field 'node[wide_slot_0][contents][][asset_id]', :to => asset.id
    end
    click_button "Publish"
    visit admin_node_path(@_content)
  end
end

Then /^I should see the list of files$/ do
  @_content.reload
  @_content.wide_slot_0.contents.should have(8).things
  response.should have_selector('ul#download-list li', :count => 8)
end

Then /^each file should have an icon based on file\-type$/ do
  response.should have_selector("ul#download-list li.file-type-#{@_content.wide_slot_0.contents.first.asset.file_mime_type.parameterize}")
end

When /^I click on a file's listing$/ do
  click_link_within("ul#download-list", @_content.wide_slot_0.contents.first.asset.title)
end

Then /^the file should start downloading$/ do
  # ||||||||||||||||||=> done
end
