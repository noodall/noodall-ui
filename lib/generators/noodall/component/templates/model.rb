class <%= class_name %> < Noodall::Component
<% for attribute in attributes -%>
  key :<%= attribute.name %>, <%= attribute.type.to_s.classify %>
<% end -%>
end
