module Susana
  class Cookie

    attr_accessor :req, :res

    # Takes a Rack request and a response
    def initialize(req, res)
      self.req = req
      self.res = res
    end

    # Get a value
    def [](key)
      req.cookies[key.to_s]
    end

    # Set a cookie. Deletes if value is nil
    def []=(key, args)
      # Extract arguments
      val, opt = args, {}; key = key.to_s

      # Extract options
      val, opt = val if val.is_a?(Array)

      # Default options: :path => '/', :expire_after => 30.days.to_i
      # Optional: domain => req.host, :secure => req.secure?, :httponly => true/false
      o = {:path => '/', :expire_after => 30.days.to_i}.merge(opt || {}).compact

      # Return cookie and delete if val is nil
      return req.cookies[key].tap{ res.delete_cookie(key)} if val.nil?

      # Set value
      res.set_cookie(key, o.merge(:value => val))
    end

  end
end
