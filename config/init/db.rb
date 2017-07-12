# Load database settings
config = (YAML.load_file('./config/database.yml') || {})[App.env]

# Connect database
if config

  # Read settings or load defaults
  uri = "#{config['url'] || 'localhost'}:#{config['port'] || 27017}"
  name = "#{config['name'] || App.name}_#{App.env}"

  # Set up logger
  # Mongo::Logger.logger.level = ::Logger::INFO
  Mongo::Logger.logger.level = ::Logger::FATAL if App.env == 'development'

  # Change these to write to log file
  # Mongo::Logger.logger = ::Logger.new('./log/mongo.log')

  # Connect. Use App.db to access database
  # https://github.com/fugroup/easymongo
  App.db = Easymongo::Query.new([uri], :database => name)

else
  puts "Database settings not found for #{App.env} in config/database.yml"
end
