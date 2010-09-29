class NodeFeaturesGenerator < ScaffoldGenerator
  
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(class_name)

      # Controller, views, test and stylesheets directories.
      m.directory(File.join('spec','factories'))
      m.directory(File.join('features'))

      m.file('../features', 'features')
    end
  end

end
