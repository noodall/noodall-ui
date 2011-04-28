module Noodall
  module Admin
    class VersionsController < BaseController
      
      def index
        @node = Node.find(params[:node_id])
        @versions = @node.versions.reverse
        render :index, :layout => false
      end
      
    end
  end
end
