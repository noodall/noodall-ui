module Noodall::Admin::AssetsHelper

  def asset_icon(asset)
    icon = case asset.file_ext
    when "doc", "pdf", "txt", "xls"
      "admin/#{asset.file_ext}-icon.png"
    else
      "admin/no-type-icon.png"
    end

    image_tag icon, :title => "#{asset.title} - #{asset.file.name}"
  end

  def system_image(asset, options)
    image_tag(system_image_url(asset, options), :alt => "#{truncate(asset.file.name, :length => 80)}")
  end

  def system_image_url(asset, options)

    if [:amazon_s3, :filesystem].include? Noodall::UI::Assets.storage
      unless asset.send(options[:image]).nil?
        return asset.send(options[:image]).remote_url
      end
    end

    asset.url('70x70', asset.web_image_extension)
  end
end
