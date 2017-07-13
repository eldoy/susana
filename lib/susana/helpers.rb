# Susana helpers

module Susana
  module Helpers

    # Render erb template
    def erb(name, options = {})
      template = Tilt['erb'].new("#{App.views}/#{name}.erb")
      render = template.render(self, options[:locals])

      # Return render unless options[:layout] is set
      return render unless options[:layout]

      # Render with layout
      layout = Tilt['erb'].new("#{App.views}/layout/#{options[:layout]}.erb")
      layout.render(self, options[:locals]) { render }
    end

    # Basic auth
    def protect!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt(401, "Not authorized\n")
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

    # Cookie management
    def cookie(*args)
      # Extract arguments
      key, value, opt = args; key = key.to_s

      # Get a value
      return req.cookies[key.to_s] if args.length == 1

      # Default options: :path => '/', :expire_after => 30.days.to_i
      # Optional: domain => req.host, :secure => req.secure?, :httponly => true/false
      o = {:path => '/', :expire_after => 30.days.to_i}.merge(opt || {}).compact

      # Return cookie and delete if value is nil
      return req.cookies[key].tap{|val| res.delete_cookie(key, o)} if value.nil?

      # Set value
      res.set_cookie(key, o.merge(:value => value))
    end

  end
end
