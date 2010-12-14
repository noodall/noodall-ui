Factory.factories.values.each do |factory|
  if factory.build_class.respond_to?(:keys)
    factory.build_class.keys.each_key do |key|
      human_column_name = key.downcase.gsub('_', ' ')
      Given /^an? #{factory.human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
        Factory(factory.factory_name, key => value)
      end

      Given /^(\d+) #{factory.human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
        count.to_i.times { Factory(factory.factory_name, key => value) }
      end
    end
  end
end
