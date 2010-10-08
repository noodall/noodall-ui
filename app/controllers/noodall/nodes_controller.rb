module Noodall
  class NodesController < ApplicationController
    def show
      if published_states_changed_since_global_update? or stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        permalink = params[:permalink].is_a?(String) ? params[:permalink] : params[:permalink].join('/')

        @node = Node.find_by_permalink(permalink)
        @page_title = @node.title
        @page_description = @node.description
        @page_keywords = @node.keywords
  
        respond_to do |format|
          format.html { render "nodes/#{@node.class.name.underscore}" }
          format.rss { render "nodes/#{@node.class.name.underscore}" }
        end
      end
    end
  
    def sitemap
      if stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        @page_title = 'Sitemap'
      end
    end
  
    def search
      @nodes = Node.search(params[:q], :per_page => 10, :page => params[:page], :published_at => { :$lte => Time.zone.now }, :published_to => { :$gte => Time.zone.now })
      @page_title = 'Searching: '+ params[:q]
    end
  
  protected
  
    def published_states_changed_since_global_update?
      if Node.count(:published_at => { :$gte => GlobalUpdateTime::Stamp.read, :$lte => Time.zone.now }).zero? and Node.count(:published_to => { :$gte => GlobalUpdateTime::Stamp.read, :$lte => Time.zone.now }).zero?
        false
      else
        GlobalUpdateTime::Stamp.update!
        true
      end
    end
  end
end
