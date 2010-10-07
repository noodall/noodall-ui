require 'dragonfly'
require 'noodall/video_thumbnail_encoder'

# Configuration for processing and encoding
app = Dragonfly::App[:noodall_assets]
app.configure_with(:rmagick)
app.configure_with(:rails)
app.encoder.register(VideoThumbnailEncoder)
app.configure do |c|
  c.datastore = Dragonfly::DataStorage::MongoDataStore.new Rails.configuration.database_configuration
  c.secret = '2406b0d72aaf812659babdf53eb49d4812c2cc59' unless Rails.env.test?
end
app.url_suffix = proc{|job|
  "/#{job.uid_basename}#{job.encoded_extname || job.uid_extname}"
}
