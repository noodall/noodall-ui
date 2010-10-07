Given /^I am using the asset library$/ do
  visit noodall_admin_assets_path
end

When /^I upload a file$/ do
  click_link "Upload"
  fill_in "Title", :with => "A loverly asset"
  attach_file("File", "#{Rails.root}/spec/files/beef.png")
end

When /^enter tags$/ do
  fill_in "Tags", :with => "you, me, things, stuff"
  fill_in "Description", :with => "Some nice info"
  click_button "Create"
end

Then /^it should appear in the asset library$/ do
  page.should_not have_content('Errors')
  page.should have_content('A loverly asset')
end

Given /^files have been uploaded to the asset library$/ do
  20.times { Factory(:asset) }
  20.times { Factory(:document_asset) }
  20.times { Factory(:video_asset) }
  
  20.times { Factory(:asset, :title => "Tagged Asset", :tags => ['RAC','lorem','dolar']) }
  
end

Then /^I should be able to browse assets by content type$/ do
  within(:css, "ul.choices") { click_link "Images" }
  page.should_not have_content('Document asset')
  page.should_not have_content('Video asset')
  within(:css, "ul.choices") { click_link "Documents" }
  page.should_not have_content('Image asset')
  page.should_not have_content('Video asset')
  within(:css, "ul.choices") { click_link "Videos" }
  page.should_not have_content('Document asset')
  page.should_not have_content('Image asset')
  
end

Then /^I should be able to browse assets by tags$/ do
  within(:css, "ul.choices") { click_link "Images" }
  within(:css, "div#tags") { click_link "RAC" }
  page.should_not have_content('Image asset')
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
