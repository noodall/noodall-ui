MongoMapper.setup(
  Rails.configuration.database_configuration,
  Rails.env,
  { :logger    => Rails.logger, :passenger => true }
)
