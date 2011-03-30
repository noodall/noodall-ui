Factory.define :<%= file_name %> do |<%= file_name %>|
  <%= file_name %>.title { Faker::Lorem.words(3).join(' ') }
  <%= file_name %>.body { Faker::Lorem.paragraphs(6) }
  <%= file_name %>.published_at { Time.now }
  <%= file_name %>.publish true
<% for attribute in attributes -%>
  <%= file_name %>.<%= attribute.name %> {Faker::Lorem.words(5).join(' ').titleize}
<% end -%>
end
