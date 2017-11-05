# Set up request, debug and error loggers
if App.live?

  # Add alias for logger class
  ::Logger.class_eval { alias :write :'<<' }

  # Make sure tmp dir exists
  Dir.mkdir('./log') unless File.exists?('./log')

  # Set up loggers
  App.logger = {}.to_dot
  App.logger.request = ::Logger.new(::File.new('./log/request.log', 'a+'))
  App.logger.debug = ::Logger.new(::File.new('./log/debug.log', 'a+'))
  App.logger.error = ::File.new('./log/error.log', 'a+')
  App.logger.error.sync = true
end
