module Noodall
  module Admin
    module NodesHelper
      include Noodall::Permalinks
      include AssetsHelper

      def admin_breadcrumb
        breadcrumbs = breadcrumb_for(
                        @parent,
                        :node_path => :noodall_admin_node_nodes_path,
                        :home_link => link_to('Content tree', noodall_admin_nodes_path)
                      )
        content_tag('ul', breadcrumbs.join.html_safe, :class => 'breadcrumb') if breadcrumbs
      end

      def sorted_node_tree(tree)
        nodes = []
        tree.each do |node|
          nodes << node
          unless node.children.empty?
            nodes += sorted_node_tree(node.children)
          end
        end

        nodes
      end

      def formatted_node_tree_options
        sorted_node_tree(Node.roots).reject{|n| n._id == @node._id}.collect{|n|
          [n.title, n._id]
        }
      end

      def slot_link(node,type,index)
        link_to( "#{type.to_s.titleize} Slot", {:anchor => "#{type}_component_form_#{index}"}, :id=> "#{type}_slot_#{index}_selector", :class => 'slot_link') +
          "<span id=\"#{type}_slot_#{index}_tag\" class=\"slot_tag\">#{node.send("#{type}_slot_#{index}").class.name.titleize unless @node.send("#{type}_slot_#{index}").nil?}</span>".html_safe
      end

      def slot_form(node,type,index)
        component = @node.send("#{type}_slot_#{index}")
        options = options_for_select([''] + Component.positions_names(type), (component._type.titleize unless component.nil?))

        render :partial => 'slot_form', :locals => { :type => type, :index => index, :component => component, :options => options, :slot_name => "#{ type }_slot_#{ index }" }
      end

      def can_change_templates?(node)
        can_publish?(node) and !node.is_a?(Home) and (node.parent.nil? ? Node.template_names : node.parent.class.template_names).length > 1
      end

      def updater_name(node)
        begin
          node.updater.full_name if node.updater
        rescue
          logger.warn 'Unable to resolve updater name: ' +  $!.message
          'Unknown'
        end
      end

      def admin_nodes_column_headings
        html = Array.new
        html << sortable_table_header(:name => "Name", :sort => "admin_title", :class => 'sort')
        html << sortable_table_header(:name => "Type", :sort => "_type", :class => 'sort')

        # Change 'position' header if we are sorting by position
        if(params[:sort] && params[:sort] != "position" || params[:order] == "descending")
          html << sortable_table_header(:name => "Position", :sort => "position", :class => 'sort')
        else
          html << sortable_table_header(:name => "Position", :sort => "position", :class => 'sort', :colspan => 2)
        end

        html << content_tag('th', 'Sub Section', :width => "120")
        html << sortable_table_header(:name => "Updated", :sort => "updated_at", :class => 'sort')
        %w{Show Publish Delete}.each{|text| html << content_tag('th', text, :width => '45')}
        html.join("\n").html_safe
      end


    end
  end
end
