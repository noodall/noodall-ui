module Noodall
  class NodesController < ApplicationController
    include Canable::Enforcers
    rescue_from MongoMapper::DocumentNotFound, ActionView::MissingTemplate, BSON::InvalidStringEncoding, :with => :render_404
    rescue_from Canable::Transgression, :with => :permission_denied

    def show
      if flash.any? or published_states_changed_since_global_update? or stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        permalink = params[:permalink].is_a?(String) ? params[:permalink] : params[:permalink].join('/')
        @node = Node.find_by_permalink(permalink)

        #Check view permissions
        enforce_view_permission(@node)

        @page_title = @node.browser_title.blank? ? @node.title : @node.browser_title
        @page_description = @node.description
        @page_keywords = @node.keywords

        respond_to do |format|
          format.html { render "nodes/#{@node.class.name.underscore}" } # Make sure IE 7 get the correct format
          format.any { render "nodes/#{@node.class.name.underscore}" }
          format.json { render :json => @node }
        end
      end
    end

    def version
      @node = Node.find!(params[:node_id])
      version = @node.all_versions.find!(params[:id])
      @node.rollback(version.pos)
      @page_title = @node.browser_title.blank? ? @node.title : @node.browser_title
      @page_description = @node.description
      @page_keywords = @node.keywords
      render "nodes/#{@node.class.name.underscore}"
    end

    def sitemap
      if stale?(:last_modified => GlobalUpdateTime::Stamp.read, :public => true)
        @page_title = 'Sitemap'
      end

      @nodes = Node.all
    end

    def search
      if params[:q].nil?
        render_404
      else
        @nodes = Node.search(params[:q], :per_page => 10, :page => params[:page], :published_at => { :$lte => Time.zone.now }, :published_to => { :$gte => Time.zone.now })
        @page_title = 'Searching: '+ params[:q]
      end
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
      # Expire any caching already set
      expires_now
      headers.delete('Last-Modified')

      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false, :content_type => "text/html"
    end

    def permission_denied
      flash[:error] = "You do not have permission to do that"

      case
      when respond_to?('permission_denied_url')
        redirect_to permission_denied_url
      when respond_to?('permission_denied_path')
        redirect_to permission_denied_path
      else
        redirect_to root_url
      end
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
