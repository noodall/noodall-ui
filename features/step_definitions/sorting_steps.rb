Given /^some nodes exist$/ do 
  Time.stub!(:now).and_return(Time.parse("01/01/2010 13:37"))
  f = Factory.build(:node)
  f.title = "A Header"
  f.save
  
  Time.stub!(:now).and_return(Time.parse("01/01/2010 14:37"))
  f = Factory.build(:node)
  f.title = "B Header"
  f.save
  
  Time.stub!(:now).and_return(Time.parse("01/01/2010 15:37"))
  f = Factory.build(:page_a)
  f.title = "C Header"
  f.save
  
end

Then /^the nodes should be ordered by "Title"$/ do
  Then %{I should see in this order: C Header, B Header, A Header}
end


Then /^the nodes should be ordered by "Type"$/ do
  Then %{I should see in this order: Page A, Noodall/Node, Noodall/Node}
end


Then /^the nodes should be ordered by "Updated"$/ do
  Then %{show me the page}
  Then %{I should see in this order: 15:37:00, 14:37:00, 13:37:00 }
end

Then /^(?:|I )should see in this order(?: within "([^\"]*)")?: (.*)$/ do |selector, text|
  order = Regexp.new(text.gsub(', ', '.*'), Regexp::MULTILINE)

  with_scope(selector) do
    raise "Did not find keywords (#{text}) in the requested order!" unless page.body =~ order
  end
end
