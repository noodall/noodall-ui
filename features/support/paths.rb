require 'noodall/permalinks'

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the (home\s?page|website)/i
      root_path
    when /the CMS/
      '/admin'
    when /^the (?:root )?content titled "([^\"]*)" page$/i
      node = Node.find_by_title($1)
      node_path(node)
    when /^the content admin page$/
      noodall_admin_nodes_path
    when /^the site ?map page$/
      noodall_sitemap_path
    when /^a page that's content is in the "([^\"]*)" template$/
      node = Node.first(:_type => $1.gsub(' ',''), :order => 'created_at DESC')
      node_path(node)
    when /^a page that's content is in the "([^\"]*)" template that does not have published children$/
      node = Factory($1.gsub(' ','_').tableize.singularize, :publish => true)
      node.children.each{|c| c.destroy }
      node_path(node)
    when /^a page that's content is in the "([^\"]*)" template that has published children$/
      node = Factory($1.gsub(' ','_').tableize.singularize, :publish => true)
      3.times do
        Factory(:page_a, :publish => true, :parent => node)
      end
      node_path(node)
    when /^that page$/
      node_path(@_content)

    when /^the article list page$/
      node_path(@_content)
    when /content titled "([^\"]*)"$/
      node_path(Node.find_by_title($1))
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find a mapping from \"#{page_name}\" to a path.\n" +
          "Please add one to #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
World(Noodall::Permalinks)
