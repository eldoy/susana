class App

  include Fuprint::Helpers

  class << self; attr_accessor :settings, :database, :name, :root, :views, :assets, :env, :map, :routes, :debug; end

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

    # Match a route
    routes = App.map[req.request_method] || []; match = nil
    route = routes.find{|r| match = r[0].params(req.path_info)}

    if match
      # puts "FOUND: #{route[1]}##{route[2]} - #{match.inspect}"

      # Merge params
      match.each{|k, v| req.update_param(k, v)}

      # Print request info
      print_info(env, req) if App.env == 'development'

      # Set up controller
      controller = Object.const_get("#{route[1].capitalize}Controller").new(req, res, env)

      # Catch halt commands
      catch(:halt) do

        # Run route method
        result = controller.send(route[2])

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
