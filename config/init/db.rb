# Load database settings
App.database = (YAML.load_file('./config/database.yml') || {})[App.env]

# Connect database
if App.database

  # Read settings or load defaults
  uri = "#{App.database['url'] || 'localhost'}:#{App.database['port'] || 27017}"
  name = "#{App.database['name'] || App.name}_#{App.env}"

  # Set up logger
  # Mongo::Logger.logger.level = ::Logger::INFO
  Mongo::Logger.logger.level = ::Logger::FATAL if App.env == 'development'

  # Change these to write to log file
  # Mongo::Logger.logger = ::Logger.new('./log/mongo.log')

  # Connect
  Minimongo.db = Mongo::Client.new([uri], :database => name)

  # Access db from $db
  $db = include(Minimongo::Query)
else
  puts "Database settings not found for #{App.env} in config/database.yml"
end
