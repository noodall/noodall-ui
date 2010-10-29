class <%= class_name %> < Noodall::Node
# sub_templates <%= class_name %>
<%- if options.root? -%>
  root_template!
<%- end -%>

# small_slots 4


<% for attribute in attributes -%>
  key :<%= attribute.name %>, <%= attribute.type.to_s.classify %>
<% end -%>
end
