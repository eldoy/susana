module ApplicationHelpers

  # Render erb template
  def erb(name, options = {})
    template = Tilt::ERBTemplate.new("#{App.views}/#{name}.erb")
    render = template.render(self, options[:locals])
    if options[:layout]
      layout = Tilt::ERBTemplate.new("#{App.views}/layout/#{options[:layout]}.erb")
      layout.render(self, options[:locals]) { render }
    else
      render
    end
  end

  # Basic auth
  def protect!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  # Check if authorized
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'test54']
  end

  # Halt execution
  def halt(*args)
    # Set status and message
    args.insert(0, 200) if args[0].is_a?(String)
    res.status = args[0]; res.write(args[1])
    throw :halt
  end

end
