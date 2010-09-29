class NodeGenerator < ScaffoldGenerator
  
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(class_name)

      # Controller, views, test and stylesheets directories.
      m.directory(File.join('spec','factories'))
      m.directory(File.join('app','views','nodes'))
      m.directory(File.join('app','views','admin','nodes'))

      m.template(
        "model.rb",
        File.join('app','models',"#{controller_file_name.singularize}.rb")
      )

      m.template(
        "template.html.erb",
        File.join('app','views','nodes', "#{controller_file_name.singularize}.html.erb")
      )
      
      m.template(
        "admin_template.html.erb",
        File.join('app','views','admin','nodes', "_#{controller_file_name.singularize}.html.erb")
      )
      
      m.template(
        "factory.rb",
        File.join('spec','factories',"#{controller_file_name.singularize}.rb")
      )
    end
  end

end
