module Susana
  class Base

    include Asset::Helpers

    attr_accessor :req, :res, :env, :params, :cookies, :session, :flash, :errors

    def initialize(req, res, env)
      self.req = req
      self.res = res
      self.env = env
      self.params = req.params
      self.cookies = Susana::Cookies.new(req, res)
      self.session = env['rack.session']
      self.flash = env['x-rack.flash']
      self.errors = Hash.new{|h, k| h[k] = []}
    end

    # Convenience for request and response objects
    def method_missing(name, *args, &block)
      return req.send(name, *args) if req.respond_to?(name)
      return res.send(name, *args) if res.respond_to?(name)
      super
    end

  end
end
