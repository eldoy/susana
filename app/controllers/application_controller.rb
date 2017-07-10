class ApplicationController

  include ApplicationHelper

  attr_accessor :req, :res, :env, :params, :cookies, :flash

  def initialize(req, res, env)
    self.req = req
    self.res = res
    self.env = env
    self.params = req.params
    self.cookies = req.cookies
    self.flash = env['x-rack.flash']
  end

  # Convenience for request and response objects
  def method_missing(name, *args, &block)
    return req.send(name, *args) if req.respond_to?(name)
    return res.send(name, *args) if res.respond_to?(name)
    super
  end

end
