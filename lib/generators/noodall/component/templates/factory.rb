Factory.define :<%= file_name %> do |<%= file_name %>|
<% for attribute in attributes -%>
  <%= file_name %>.<%= attribute.name %> {Faker::Lorem.words(5).join(' ').titleize}
<% end -%>
end
