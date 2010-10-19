module Noodall::Admin::BaseHelper
  def admin_page_title
    @page_title ||= controller.controller_name.titleize + (controller.action_name == 'index' ? ' ' : " | #{controller.action_name.titleize}" )
  end
end
