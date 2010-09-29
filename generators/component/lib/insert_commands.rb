# Mostly pinched from http://github.com/ryanb/nifty-generators/tree/master
Rails::Generator::Commands::Base.class_eval do
  def file_contains?(relative_destination, line)
    File.read(destination_path(relative_destination)).include?(line)
  end
end

Rails::Generator::Commands::Create.class_eval do

  def route_resources_to_namespace(namespace, resource_list)
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    namespace_map = "map.namespace(:#{namespace}) do |#{namespace}|"
    logger.route namespace_map
    unless options[:pretend] || file_contains?('config/routes.rb', namespace_map)
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  #{namespace_map}\n  end"
      end
    end
    
    namespace_route = "#{namespace}.resources :#{resource_list}"

    logger.route namespace_route
    unless options[:pretend] || file_contains?('config/routes.rb', namespace_route)
      gsub_file 'config/routes.rb', /(#{Regexp.escape(namespace_map)})/mi do |match|
        "#{match}\n    #{namespace_route}"
      end
    end
  end
  
end

Rails::Generator::Commands::Destroy.class_eval do
  
  def route_resources_to_namespace(namespace, resource_list)
    # do ni
  end

  def insert_into(file, line)
    logger.remove "#{line} from #{file}"
    unless options[:pretend]
      gsub_file file, "\n  #{line}", ''
    end
  end

end

Rails::Generator::Commands::List.class_eval do

  def route_resources_to_namespace(namespace, resource_list)
    namespace_map = "map.namespace(:#{namespace}) do |#{namespace}|"
    logger.route namespace_map
    namespace_route = "#{namespace}.resources :#{resource_list}"
    logger.route namespace_route
  end
    
  def insert_into(file, line)
    logger.insert "#{line} into #{file}"
  end

end