module Noodall
  module Admin
    class KeywordsController < BaseController
      caches_action :index, :expires_in => 1.hour
      def index
        keywords = Noodall::Node.tag_cloud.collect(&:name).uniq.sort
        render :json => keywords
      end
    end
  end
end
