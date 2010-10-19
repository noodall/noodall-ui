module Noodall
  module Admin
    class GroupsController < BaseController
      caches_action :index, :expires_in => 1.hour
      def index
        groups = []
        render :json => groups
      end
    end
  end
end
