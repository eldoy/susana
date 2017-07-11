module Susana
  class Cookies

    attr_accessor :req, :res

    # Pass a request and a reponse
    def initialize(req, res)
      self.req = req
      self.res = res
    end

    # Get a value
    def [](key)
      req.cookies[key.to_s]
    end

    # Cookie management
    def []=(*args)
      # Extract arguments
      key, value, opt = args; key = key.to_s

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
