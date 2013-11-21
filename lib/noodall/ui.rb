module Noodall
  module UI
    class << self
      attr_accessor :menu_items
      attr_accessor :app_name
      attr_accessor :system_name
    end

    self.menu_items = ActiveSupport::OrderedHash[
      'Contents', :noodall_admin_nodes_path,
      'Assets', :noodall_admin_assets_path
    ]

    self.app_name = "Noodall"
    self.system_name = "Content Management System"

    module Assets
      class << self
        attr_accessor :storage
        attr_accessor :system_image_sizes
        attr_accessor :image_sizes
      end

      self.storage = :mongo_gridfs
      self.system_image_sizes = { :system_thumb => '70x70' }
      self.image_sizes = {}
    end
  end
end

