module Susana
  class Base

    include Asset::Helpers, Susana::Helpers

    attr_accessor :req, :res, :env, :params, :errors, :session, :flash

    # Set up controller data
    def initialize(req, res, env)
      self.req = req
      self.res = res
      self.env = env
      self.params = HashWithIndifferentAccess.new(req.params)
      self.errors = HashWithIndifferentAccess.new{|h, k| h[k] = []}
      self.session = env['rack.session']
      self.flash = env['x-rack.flash']
    end

    # Access request and response objects
    def method_missing(name, *args, &block)
      return req.send(name, *args) if req.respond_to?(name)
      return res.send(name, *args) if res.respond_to?(name)
      super
    end

  end
end
