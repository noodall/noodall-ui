require 'factory_girl_rails'
require 'faker'
require 'factory_girl/step_definitions'

FactoryGirl.factories.each do |factory|
  factory.human_names.each do |human_name|
    if factory.build_class.respond_to?(:keys)
      factory.build_class.keys.each_key do |key|
        human_column_name = key.downcase.gsub('_', ' ')
        Given /^an? #{human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
          Factory(factory.name, key => value)
        end

        Given /^(\d+) #{human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
          count.to_i.times { Factory(factory.name, key => value) }
        end
      end
    end
  end
end
