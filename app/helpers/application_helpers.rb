# Add your helpers here

module ApplicationHelpers

  # Render erb template
  def erb(name, options = {})
    template = Tilt::ERBTemplate.new("#{App.views}/#{name}.erb")
    render = template.render(self, options[:locals])

    # Return render unless options[:layout] is set
    return render unless options[:layout]

    # Render with layout
    layout = Tilt::ERBTemplate.new("#{App.views}/layout/#{options[:layout]}.erb")
    layout.render(self, options[:locals]) { render }
  end

  # Basic auth
  def protect!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  # Check if authorized
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(req.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [App.settings.http_basic_user, App.settings.http_basic_password]
  end

  # Halt execution
  def halt(*args)
    # Set status and message
    args.insert(0, 200) if args[0].is_a?(String)
    res.status = args[0]; res.write(args[1])
    throw :halt
  end

  # Translation helpers
  def t(*args); I18n.t(*args); end
  def l(*args); I18n.l(*args); end

end
