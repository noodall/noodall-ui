module Noodall
  class NodesController < ApplicationController
    include Canable::Enforcers
    rescue_from MongoMapper::DocumentNotFound, ActionView::MissingTemplate, :with => :render_404
    rescue_from Canable::Transgression, :with => :permission_denied

    def show
      if flash.any? or published_states_changed_since_global_update? or stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        permalink = params[:permalink].is_a?(String) ? params[:permalink] : params[:permalink].join('/')
        @node = Node.find_by_permalink(permalink)

        #Check view permissions
        enforce_view_permission(@node) if anybody_signed_in?

        @page_title = @node.title
        @page_description = @node.description
        @page_keywords = @node.keywords

        respond_to do |format|
          format.json { render :json => @node }
          format.any { render "nodes/#{@node.class.name.underscore}" }
        end
      end
    end

    def sitemap
      if stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        @page_title = 'Sitemap'
      end

      @nodes = Node.all
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

    def render_404(exception = nil)
      if exception
        logger.info "Rendering 404: #{exception.message}"
      end

      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => "text/html"
    end

    def permission_denied
      flash[:error] = "You do not have permission to do that"
      redirect_to root_url
    end

    def can_view?(node)
      if node.viewable_groups.empty?
        # No groups then can view
        true
      else
        #Set cache control to private if this page has restricted permisions
        response.cache_control[:public] = false
        !current_user.nil? and current_user.can_view?(node)
      end
    end
  end
end
