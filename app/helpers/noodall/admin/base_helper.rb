module Noodall::Admin::BaseHelper
  include Noodall::LayoutHelper
  def admin_page_title
    @page_title ||= controller.controller_name.titleize +
      (controller.action_name == 'index' ? ' ' : " | #{controller.action_name.titleize}" ) +
      " | #{Noodall::UI.app_name}"
  end

  def admin_menu_items
    Noodall::UI.menu_items.map do |title, link|
      content_tag :li, link_to( title, send(link) )
    end.join.html_safe
  end
end
