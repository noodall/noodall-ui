Given /^I am editing content$/ do
  @_content = Factory(:page_a)
  visit noodall_admin_node_path(@_content)
end

When /^I select a module area$/ do
  page.should have_css('ol#slot-list')
end

Then /^I should be able to set the module and its content$/ do
  page.should have_css('select.component-selector')
end

When /^I choose the "([^\"]+)" module$/ do |module_name|

  case module_name
  when 'Hero Panel'
    @_slot_type = 'main'
  when 'Open Day List'
    @_slot_type = 'wide'
  else
    @_slot_type = 'wide'
  end

  within("div.#{@_slot_type}-slot") do |form|
    form.select module_name, :from => 'Select the type of component'
  end
  @_content.send("#{@_slot_type}_slot_0=", Factory(module_name.gsub(' ','_').downcase.to_sym))
  @_content.save!
  # Reopen page so we can fill in the the form
  visit noodall_admin_node_path(@_content)
end

When /^I select an image from the asset library \(optional\)$/ do
  asset = Factory(:asset)
  within "#slot-list" do
    set_hidden_field "node[#{@_slot_type}_slot_0][asset_id]", :to => asset.id
  end
end

When /^I enter a title \(optional\)$/ do
  within "#slot-list" do
    fill_in 'Title', :with => 'Test Title One'
  end
end

When /^I enter some text$/ do
  within "#slot-list" do
    fill_in 'Body', :with => 'Test Content One'
  end
end

When /^I enter link text \(optional\)$/ do
  within "#slot-list" do
    fill_in 'Url Label', :with => 'More'
  end
end

When /^set a URL \(optional\)$/ do
  within "#slot-list" do
    fill_in 'Url', :with => 'http://www.google.com'
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

Given /^an articles list exists with a title of "([^\"]*)" with articles published on:$/ do |title, table|
  articles_list = Factory(:articles_list, :title => title, :publish => true)
  table.hashes.each do |rows|
    Factory(:article_page, :parent => articles_list, :publish => true, :published_at => rows['Date'].to_time)
  end
end

Then /^I should see the the archive$/ do
  within("div##{@_slot_type}_slot_0.archive") do |slot|
    slot.should contain('Archive')
  end
end

Then /^I should see 2 articles$/ do
  response.should have_css("div.news-block", :count => 2)
end

Then /^when I click in the more link$/ do
  within("div##{@_slot_type}_slot_0.general-content") do |slot|
    slot.should contain('More')
  end
end

Then /^I should be taken to the url$/ do
  response.should have_css("div##{@_slot_type}_slot_0.general-content a[href='http://www.google.com']")
end




Then /^I enter a gallery title$/ do
  within "#slot-list" do
    fill_in "node[#{@_slot_type}_slot_0][title]", :with => 'Gallery 1'
  end
end

Then /^I enter a gallery description \(optional\)$/ do
  within "#slot-list" do
    fill_in "node[#{@_slot_type}_slot_0][body]", :with => 'This is the first Gallery'
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
  visit noodall_admin_node_path(@_content)
end

Then /^I should be able to select the gallery style from "widget" and "list"$/ do
  within("#wide_component_form_0 select#node_wide_slot_0_style") do |select|
    select.should contain('widget')
    select.should contain('list')
  end
end

Then /^I should not be able to select the gallery style$/ do
  response.should_not have_css("#small_component_form_0 select#node_small_slot_0_style")
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
  response.should have_css("ul.gallery.widget li img", :count => 5)
end

Then /^I should see all the gallery thumbnails$/ do
  response.should have_css("ul.gallery.list li img", :count => 5)
end

Then /^I enter the same for more images$/ do
  click_button "Publish"
  visit noodall_admin_node_path(@_content)
  3.times do |i|
    within "li.multi-file:last" do
      asset = Factory(:asset)
      set_hidden_field "node[#{@_slot_type}_slot_0][contents][][asset_id]", :to => asset.id
      fill_in "node[#{@_slot_type}_slot_0][contents][][title]", :with => "Image #{i+2}"
      fill_in "node[#{@_slot_type}_slot_0][contents][][body]", :with => "The Image number #{i+2}"
      fill_in "node[#{@_slot_type}_slot_0][contents][][url]", :with => 'http://www.google.com'
    end
    click_button "Publish"
    visit noodall_admin_node_path(@_content)
  end
end

Then /^I should see the (gallery thumbnails|slideshow)$/ do |type|
  @_content.reload
  @_content.send("#{@_slot_type}_slot_0").contents.should have(9).things
  case type
  when "gallery thumbnails"
    response.should have_css("ul.gallery li img", :count => 9)
  when "slideshow"
    class_name = ""
    response.should have_css("dl.hero-panel dt img", :count => 9)
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
  response.should have_css("ul.gallery li:nth(2) a[href='#{@_image.url}']")
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
    visit noodall_admin_node_path(@_content)
  end
end

Then /^I should see the list of files$/ do
  @_content.reload
  @_content.wide_slot_0.contents.should have(8).things
  response.should have_css('ul#download-list li', :count => 8)
end

Then /^each file should have an icon based on file\-type$/ do
  response.should have_css("ul#download-list li.file-type-#{@_content.wide_slot_0.contents.first.asset.file_mime_type.parameterize}")
end

When /^I click on a file's listing$/ do
  click_link_within("ul#download-list", @_content.wide_slot_0.contents.first.asset.title)
end

Then /^the file should start downloading$/ do
  # ||||||||||||||||||=> done
end
