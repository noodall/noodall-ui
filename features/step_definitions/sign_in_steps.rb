Given /^I am signed in as a(?:n|) (.*)$/ do |role|
  ApplicationController.current_user = Factory(:user, :groups => [role])
end
