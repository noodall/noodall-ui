module Noodall
  module Admin
    class VersionsController < BaseController

      def index
        @node = Node.find(params[:node_id])
        @versions = @node.all_versions.order('pos DESC').paginate(:page => params[:page], :per_page => 10)
        render :index, :layout => false
      end

    end
  end
end
