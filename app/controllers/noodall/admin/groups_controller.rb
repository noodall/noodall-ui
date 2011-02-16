module Noodall
  module Admin
    class GroupsController < BaseController
      caches_action :index, :expires_in => 1.hour
      def index
        render :json => respond_to?(:user_groups) ? user_groups : []
      end
    end
  end
end
