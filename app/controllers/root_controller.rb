class RootController < ApplicationController

  def home
    c['user'] = 'hello'
    erb('root/home', :layout => 'default')
  end

  def login
    session[:user] = '1'
  end

  def user
    'USER'
  end
end
