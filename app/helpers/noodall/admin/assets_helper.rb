module Noodall::Admin::AssetsHelper
  include SortableTable::App::Helpers::ApplicationHelper

  def asset_icon(asset)
    icon = case asset.file_ext
    when "doc", "pdf", "txt", "xls"
      "admin/#{asset.file_ext}-icon.png"
    else
      "admin/no-type-icon.png"
    end

    image_tag icon, :title => "#{asset.title} - #{asset.file.name}"
  end

end
