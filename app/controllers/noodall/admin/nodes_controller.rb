module Noodall
  module Admin
    class NodesController < ApplicationController
      layout 'noodall_admin'
      before_filter :set_title

      def index
        if params[:node_id].nil?
          @nodes = Node.roots
        else
          @parent = Node.find(params[:node_id])
          @nodes = @parent.children
        end

        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @nodes }
        end
      end

      def tree
        @options = {}
        @options[:_type] = params[:allowed_types] if params[:allowed_types]
        if params[:not_branch]
          @options.merge!(
            :_id => {"$ne" => BSON::ObjectID.from_string(params[:not_branch])},
            Node.path_field => {"$ne" => BSON::ObjectID.from_string(params[:not_branch])}
          )
        end

        respond_to do |format|
          format.html
          format.js
        end
      end

      def show
        @node = Node.find(params[:id])
        enforce_update_permission(@node)
        enforce_publish_permission(@node) if @node.published?

        respond_to do |format|
          format.html
          format.xml  { render :xml => @node }
        end
      end

      def new
        @parent = Node.find(params[:node_id])
        @node = Node.new( :parent => @parent )
        enforce_create_permission(@node)

        @template_names = @parent.nil? ? Node.template_names : @parent.class.template_names
        respond_to do |format|
          format.html
          format.xml  { render :xml => @node }
        end
      end

      def create
        template_class = params[:node].delete(:template).to_s.gsub(' ','').constantize
        @node = template_class.new(params[:node])
        enforce_create_permission(@node)

        # Set user stamps
        @node.creator = @node.updater = current_user

        respond_to do |format|
          if @node.save
            flash[:notice] = "#{@node.class.name.titleize} '#{@node.title}' was successfully created."
            format.html { redirect_to noodall_admin_node_path(@node) }
            format.xml  { render :xml => @node, :status => :created, :location => @node }
          else
            format.html do
              @parent = @node.parent
              @template_names = @parent.nil? ? Node.template_names : @parent.class.template_names
              render :action => "new"
            end
            format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
          end
        end
      end

      def update
        @node = Node.find(params[:id])
        enforce_update_permission(@node)
        enforce_publish_permission(@node) if @node.published?

        # Set user stamp
        @node.updater = current_user

        respond_to do |format|
          if @node.update_attributes(params[:node])
            flash[:notice] = "#{@node.class.name.titleize} '#{@node.title}' was successfully updated."
            format.html {
              if @node.parent.nil?
                redirect_to noodall_admin_nodes_path
              else
                redirect_to noodall_admin_node_nodes_path(@node.parent.id)
              end
            }
            format.xml  { head :ok }
          else
            format.html { render :action => "show" }
            format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
          end
        end
      end

      def destroy
        @node = Node.find(params[:id])
        enforce_destroy_permission(@node)

        @node.destroy
        flash[:notice] = "#{@node.class.name.titleize} '#{@node.title}' was successfully deleted."

        respond_to do |format|
          format.html { redirect_to(noodall_admin_nodes_url) }
          format.xml  { head :ok }
        end
      end

      def move_up
        @node = Node.find(params[:id])
        enforce_update_permission(@node)
        @node.move_higher
        redirect_to :back
      end

      def move_down
        @node = Node.find(params[:id])
        enforce_update_permission(@node)
        @node.move_lower
        redirect_to :back
      end

      def preview
        @node = Node.find(params[:id])
        @node.attributes = params[:node]
        @node.permalink ||= 'preview'
        render :template => "/nodes/#{@node.class.name.underscore}", :layout => 'application'
      end


      def change_template
        @node = Node.find(params[:id])
        enforce_update_permission(@node)
        @template_names = @node.parent.nil? ? Node.template_names : @node.parent.class.template_names
      end


      private
      def set_title
        @page_title = 'Content'
      end
    end
  end
end
