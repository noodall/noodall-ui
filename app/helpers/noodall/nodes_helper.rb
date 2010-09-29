module Noodall::NodesHelper

  def paginated_articles(&block)
    options = { :per_page => 10, :page => params[:page] }
    if params[:year]
      time = Time.zone.local(params[:year], params[:month] || 1, 1)
      if params[:month]
        options[:published_at] = { :$gt => time.beginning_of_month, :$lt => time.end_of_month }
      else
        options[:published_at] = { :$gt => time.beginning_of_year, :$lt => time.end_of_year }
      end
    end
    articles = @node.articles(options)
    paginated_section(articles) { yield(articles) }
  end

  def paginated_events(&block)
    options = { :per_page => 10, :page => params[:page] }
    events = @node.events(options)
    paginated_section(events) { yield(events) }
  end

  def sitemap(tree)
    list_children(tree, nil, 'sitemap')
  end

  def list_children(tree, parent, id_prefix = nil, level_limit = 0)
    # find the root node element or the parent's element
    parent_id = (parent.nil? ? parent.to_s : parent.id.to_s)
    
    return if tree[parent_id].nil? or tree[parent_id].empty?
    content_tag 'ol', :id => (id_prefix.nil? ? '' : "#{id_prefix}-") + "node-tree-#{(parent.nil? ? 'root' : parent_id)}" do
      tree[parent_id].collect do |n|
        content = link_to(h(n.title), node_path(n))      
        
        # Study Landing pages need to show a level further than all other nodes
        tree_limit = level_limit
        tree_limit += 1 if n.is_a? StudyLandingPage and !level_limit.zero?


        # only recurse if there is no limit and the limit has not been exceeded and if there are child nodes
        if (level_limit.zero? || tree_limit > n.path.count) && !tree[n.id.to_s].nil?
          class_name = " has-children"
          content += list_children(tree, n, id_prefix, level_limit) + "\n"
        end
        
        content_tag('li', content, {:id => "nav-#{n.permalink.join('-')}", :class => class_name}) + "\n"
      end
    end
  end

  def breadcrumb
    return if @node.nil?
    links = @node.ancestors.inject([]) do |l, n|
      l << content_tag( :li, link_to(h(n.title), node_path(n)))
    end
    links << content_tag( :li, h(@node.title) )
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

    nodes = ref_node.related(publish_options(options.merge(:order => 'published_at DESC')))
    return if nodes.empty?

    content_tag('h2', 'Related Content') +
    content_tag('ul', :id => 'related-content') do
      nodes.collect do |node|
        content_tag('li', link_to(h(node.title), node_path(node)) + node.published_at.to_formatted_s(:short_dot))
      end
    end
  end
  
  def link_to_programme_manager_profile(node)
    # link to unless seems to still evaluates the url param, even if the unless passes
    if node.programme_manager_profile_page.nil?
      h(node.programme_manager)
    else
      link_to h(node.programme_manager), node_path(node.programme_manager_profile_page)
    end
  end
end
