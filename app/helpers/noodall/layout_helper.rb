module Noodall::LayoutHelper
  def page_class
    @node.nil? ? controller_name : "#{@node.class.name.underscore.parameterize} #{@node.permalink.join(' ')}"
  end

  def page_id
    @node.nil? ? "#{controller_name}-#{action_name}" : @node.permalink.join('-')
  end

  def page_title
    @page_title ||= controller.controller_name.titleize + (controller.action_name == 'index' ? " #{controller.action_name.titleize}" : ' ' )
  end

  attr_reader :page_description, :page_keywords

  # Render flash messages
  def flash_messages
    return if flash.empty?
    flash_divs = flash.collect do |key, value|
      content_tag :div, h( value ), :class => "flash #{key}"
    end

    content_tag :div, flash_divs.join, :id => "flash"
  end 
end
