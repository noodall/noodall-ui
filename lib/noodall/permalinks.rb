module Noodall::Permalinks
  # Handy place for all the permalink methods
  def node_path(node, options = {})
    node_permalink_path node.permalink, options
  end

  def node_url(node, options = {})
    node_path(node, options.merge(:only_path => false))
  end
end
