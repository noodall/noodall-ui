Then /^the title should be "([^"]*)"$/ do |text|
  find(:xpath, "//h1[contains(text(),'#{text}')]").should_not(be_nil, "Could not find the text '#{text}' within the h1 tag")
end

Then /^the browser title should be "([^"]*)"$/ do |text|
find(:xpath, "//title[contains(text(),'#{text}')]").should_not(be_nil, "Could not find the text '#{text}' within the title tag")
end