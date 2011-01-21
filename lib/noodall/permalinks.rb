module Noodall
  module Permalinks
    # Handy place for all the permalink methods
    def node_path(node, options = {})
      node = node.is_a?(String) ? node : node.permalink.to_s
      node_permalink_path node, options
    end

    def node_url(node, options = {})
      node_path(node, options.merge(:only_path => false))
    end
  end
end
