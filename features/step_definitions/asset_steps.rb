Given /^I am using the asset library$/ do
  visit admin_assets_path
end

When /^I upload a file$/ do
  click_link "Upload"
  fill_in "Title", :with => "A loverly asset"
  attach_file("File", "#{Rails.root}/public/images/rails.png", 'image/png')
end

When /^enter tags$/ do
  fill_in "Tags", :with => "you, me, things, stuff"
  fill_in "Description", :with => "Some nice info"
  click_button "Create"
end

Then /^it should appear in the asset library$/ do
  response.should_not contain('Errors')
  response.should contain('A loverly asset')
end

Given /^files have been uploaded to the asset library$/ do
  20.times { Factory(:asset) }
  20.times { Factory(:document_asset) }
  20.times { Factory(:video_asset) }
  
  20.times { Factory(:asset, :title => "Tagged Asset", :tags => ['RAC','lorem','dolar']) }
  
end

Then /^I should be able to browse assets by content type$/ do
  click_link_within "ul.choices", "Images"
  response.should_not contain('Document asset')
  response.should_not contain('Video asset')
  click_link_within "ul.choices", "Documents"
  response.should_not contain('Image asset')
  response.should_not contain('Video asset')
  click_link_within "ul.choices", "Videos"
  response.should_not contain('Document asset')
  response.should_not contain('Image asset')
  
end

Then /^I should be able to browse assets by tags$/ do
  click_link_within "ul.choices", "Images"
  click_link_within "div#tags", "RAC"
  response.should_not contain('Image asset')
end

When /^I click insert a file$/ do
  pending # express the regexp above with the code you wish you had
end

When /^select a file from the asset library$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the asset should appear in the content editor$/ do
  pending # express the regexp above with the code you wish you had
end