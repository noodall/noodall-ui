Factory.define :asset do |asset|
  asset.tags { Faker::Lorem.words(4) }
  asset.title { "Image asset" }
  asset.description { "The asset description" }
  asset.file { File.new("#{Rails.root}/files/beef.png") }
end

Factory.define :document_asset, :parent => :asset do |asset|
  asset.title { "Document asset" }
  asset.file { File.new("#{Rails.root}/files/test.pdf") }
end

Factory.define :video_asset, :parent => :asset do |asset|
  asset.title { "Video asset" }
  asset.file { File.new("#{Rails.root}/files/get_video.flv") }
end
