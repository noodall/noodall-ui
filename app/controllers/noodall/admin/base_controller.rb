module Noodall
  module Admin
    class BaseController < ApplicationController
      layout 'noodall_admin'
      before_filter :authenticate_user!

      rescue_from Canable::Transgression, :with => :permission_denied

      private
        def permission_denied
          flash[:error] = "You do not have permission to do that"
          redirect_to :back
        end
    end
  end
end
