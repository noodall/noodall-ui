class <%= singular_name.camelize %> < Noodall::Node
# sub_templates <%= singular_name.camelize %>
# root_template!

# small_slots 4


<% for attribute in attributes -%>
  key :<%= attribute.name %> 
<% end -%>  
end
