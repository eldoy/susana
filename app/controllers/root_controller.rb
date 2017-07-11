class RootController < ApplicationController

  def home
    cookies[:user] = 'hello'
    erb('root/home', :layout => 'layout')
  end

  def login
    session[:user]
  end

  def user
    'USER'
  end
end
