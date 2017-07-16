class App

  include Fuprint::Helpers

  class << self
    attr_accessor :settings, :db, :name, :root, :views, :assets, :env, :map, :routes, :regex, :mail, :sitemap, :store, :debug
  end

  def initialize(app = nil)
    @app = app
  end

  def call(env)
    dup.call!(env)
  end

  def call!(env)
    # Set up request
    req = Rack::Request.new(env)

    # Set up response
    res = Rack::Response.new

    # puts "REQUEST METHOD: #{req.request_method}"
    # puts "PATH INFO: #{req.path_info}"

    # Set up locale
    req.path_info =~ App.regex.locale
    I18n.locale = $1 || :en

    # puts "LOCALE: #{I18n.locale}"

    # Match a route
    map = App.map[req.request_method] || []; match = nil
    entry = map.find{|r| match = r[0].params(req.path_info)}

    if match
      # Extract name and action
      name, action = entry[1], entry[2]

      # puts "ENTRY: #{name}##{action} - #{match.inspect}"

      # Merge params
      match.each{|k, v| req.update_param(k, v)}

      # Print request info
      print_info(env, req) if App.env == 'development'

      # Get the route info for this map
      route = App.routes["#{name}##{action}"]

      # Set up controller
      controller = Object.const_get("#{name.capitalize}Controller").new(req, res, env)

      # Catch halt commands
      catch(:halt) do

        # Run before, filter and validation methods
        %w[before filters validations].each do |type|
          route[type].each{|m| controller.send(m)}
        end

        # Run route method
        result = controller.send(action)

        # Run after methods
        route['after'].each{|m| controller.send(m)}

        # Write result
        res.write(result)
      end

    else

      # Not found
      puts "Not found."
      res.status = 404
    end

    # Finish response
    res.finish
  end
end
