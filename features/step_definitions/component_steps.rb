Given /^I am editing content$/ do
  @_content = Factory(:page_a)
  visit noodall_admin_node_path(@_content)
end

When /^(?:|I )click a "([^"]*)" component slot$/ do |slot_name|
  @_slot_type = slot_name.downcase
  within('ol#slot-list') do
    click_link "#{slot_name} Slot"
  end
end

When /^(?:|I )select the "([^\"]+)" component$/ do |component_name|
  within "#fancybox-content" do
    select component_name, :from => 'Select the type of component'
  end
end

When /^(?:|I )fill in the following within the component:$/ do |fields|
  within "#fancybox-content" do
    fields.rows_hash.each do |name, value|
      step %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )press "([^"]*)" within the component$/ do |button|
  within "#fancybox-content" do
    click_button(button)
  end
  sleep 3
end

When /^(?:|I )select an image from the asset library$/ do
  asset = Factory(:asset, :title => "My Image")
  within "#fancybox-content" do
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

Then /^I add some images to from the asset library$/ do
  5.times do |i|
    Factory(:asset, :title => "Image #{i}")
  end
  page.find(:css, 'span.add-multi-asset').click
  3.times do |i|
    within "#asset-browser li:nth(#{i + 1})" do
      click_link "Add"
    end
  end
  page.find(:css, 'li.action a').click
end

Then /^I should see the gallery thumbnails$/ do
  page.should have_css("ul.gallery li img", :count => 3)
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
