module Noodall
  class TemplateGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

    check_class_collision

    class_option :root, :type => :boolean, :default => false, :desc => "Can be a root node"
    class_option :factory, :type => :boolean, :default => true, :desc => "Include Factory Girl factory"
    class_option :parent, :type => :string, :desc => "The parent class for the generated model"


    def create_node_files
      template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      template "template.html.erb", "app/views/nodes/#{file_name}.html.erb"
      template "admin_template.html.erb", "app/views/admin/nodes/_#{file_name}.html.erb"
      template "factory.rb", "spec/factories/#{file_name}.rb" if options.factory?
    end

  end
end
