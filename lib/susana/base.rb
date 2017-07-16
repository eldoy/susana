module Susana
  class Base

    include Asset::Helpers, Susana::Helpers

    attr_accessor :req, :res, :env, :p, :e, :s, :c, :f

    # Set up controller data
    def initialize(req, res, env)
      self.req = req
      self.res = res
      self.env = env
      self.p = HashWithIndifferentAccess.new(req.params)
      self.e = Susana::Error.new
      self.s = env['rack.session']
      self.c = Susana::Cookie.new(req, res)
      self.f = env['x-rack.flash']
    end

    # Access request and response objects
    def method_missing(name, *args, &block)
      return App.send(name, *args) if App.respond_to?(name)
      return req.send(name, *args) if req.respond_to?(name)
      return res.send(name, *args) if res.respond_to?(name)
      super
    end

  end
end
