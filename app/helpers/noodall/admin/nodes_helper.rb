module Noodall
  module Admin
    module NodesHelper
      include Noodall::Permalinks
      include AssetsHelper

      def admin_breadcrumb
         breadcrumbs = breadcrumb_for(@parent, :node_path => :noodall_admin_node_nodes_path)
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
    end
  end
end
