class RootController < ApplicationController

  def home
    cookies[:user] = 'hello'
    erb('root/home', :layout => 'default')
  end

  def login
    session[:user]
  end

  def user
    'USER'
  end
end
