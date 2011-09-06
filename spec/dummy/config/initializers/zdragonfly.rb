# Configuration for processing and encoding
app = Dragonfly::App[:noodall_assets]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => MongoMapper.database
