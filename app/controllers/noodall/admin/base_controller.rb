module Noodall
  module Admin
    class BaseController < ApplicationController
      layout 'noodall_admin'
      before_filter :authenticate_user!

      rescue_from Canable::Transgression, :with => :permission_denied

      private
        def permission_denied
          flash[:error] = "You do not have permission to do that"
          if request.headers["Referer"]
            redirect_to :back
          else
            redirect_to root_path
          end
        end

        def enforce_editor_permission
          raise Canable::Transgression unless current_user.admin? or !current_user.respond_to?('editor?') or current_user.editor?
        end
    end
  end
end
