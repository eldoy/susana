class RootController < ApplicationController

  # GET /
  def home
    erb('root/home', :layout => :default)
  end

end
