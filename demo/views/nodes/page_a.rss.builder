xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title(@node.title)
    xml.link(node_url(@node))
    xml.language('en-gb')
  end
end
