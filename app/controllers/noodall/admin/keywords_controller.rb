module Noodall
  module Admin
    class KeywordsController < BaseController
      def index
        keywords = Noodall::Node.tag_cloud.collect(&:name).uniq.sort
        render :json => keywords
      end
    end
  end
end
