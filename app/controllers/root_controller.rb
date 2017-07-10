class RootController < ApplicationController

  def home
    erb('root/home', :layout => 'layout')
  end

  def login
    'LOGIN'
  end

  def user
    'USER'
  end
end
