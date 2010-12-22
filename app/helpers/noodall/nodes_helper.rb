module Noodall
  module NodesHelper
    include Noodall::Permalinks

    def sitemap(tree)
      list_children(tree, nil, 'sitemap')
    end

    def list_children(tree, parent, id_prefix = nil, level_limit = 0)
      # find the root node element or the parent's element
      parent_id = (parent.nil? ? parent.to_s : parent.id.to_s)

      return if tree[parent_id].blank?
      content_tag 'ol', :id => (id_prefix.nil? ? '' : "#{id_prefix}-") + "node-tree-#{(parent.nil? ? 'root' : parent_id)}" do
        tree[parent_id].collect do |n|
          content = link_to(h(n.title), node_path(n))
          # only recurse if there is no limit and the limit has not been exceeded and if there are child nodes
          if (level_limit.zero? || level_limit > n.path.count) && !tree[n.id.to_s].nil?
            class_name = " has-children"
            content += list_children(tree, n, id_prefix, level_limit)
          end
          content_tag('li', content, {:id => "nav-#{n.permalink.join('-')}", :class => class_name})
        end.join.html_safe
      end
    end

    def breadcrumb
      return if @node.nil?
      links = @node.ancestors.inject([]) do |l, n|
        l << content_tag( :li, link_to(h(n.title), node_path(n)))
      end
      links << content_tag( :li, h(@node.title) )
    end

    # get an organised grouped index of nodes for the primary nav
    def node_tree
      @node_tree ||= Node.all({:fields => "title, permalink, parent_id, _id, path, _type", :published_at => { :$lte => Time.zone.now }, :published_to => { :$gte => Time.zone.now }, :order => 'parent_id ASC, position ASC'}).group_by{|n| n.parent_id.to_s }
    end

    def node_nav(node = nil)
      # use a passed in node maybe
      current_node = (node || @node)

      return unless node_has_nav?(current_node)

      content_tag('ul', :id => 'sub-page-nav', :class => 'level-1') do
        node_tree[current_node.root.id.to_s].collect do |node|
          render :partial => 'nodes/node_nav', :locals => {:current_node => current_node, :child_node => node}
        end
      end
    end

    def node_has_nav?(node = nil)
      current_node = (node || @node)
      !(current_node.nil? or node_tree[current_node.root.id.to_s].nil?)
    end

    def related_content(ref_node, types =[], options = {})
      options[:_type] = {'$in' => types} unless types.empty?

      nodes = ref_node.related(options.merge(:order => 'published_at DESC', :published_at => { :$lte => Time.zone.now }, :published_to => { :$gte => Time.zone.now }))
      return if nodes.empty?

      content_tag('h2', 'Related Content') +
        content_tag('ul', :id => 'related-content') do
        nodes.collect do |node|
          content_tag('li', link_to(h(node.title), node_path(node)) + node.published_at.to_formatted_s(:short_dot))
        end
        end
    end
  end
end
