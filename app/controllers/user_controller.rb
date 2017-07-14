class UserController < ApplicationController

  # GET /signup
  def signup
    erb('user/signup', :layout => :default)
  end

  # POST /create
  def create
    user_validation
    if e.any?
      f.now[:error] = 'Please correct the errors below'
      erb('user/signup', :layout => :default)
    else
      App.db.users.set(:email => p[:email], :password => p[:password]).tap{|r| s[:user] = r.id}
      f[:info] = 'Welcome to Susana!'
      redirect('/')
    end
  end

  # GET /login
  def login
    erb('user/login', :layout => :default)
  end

  # POST /session
  def session
    user = App.db.users.first(:email => p[:email], :password => p[:password])
    if user
      s[:user] = user.id
      f[:info] = 'Welcome back!'
      redirect('/')
    else
      f.now[:error] = 'Email / password combination not found'
      erb('user/login', :layout => :default)
    end
  end

  # GET /logout
  def logout
    s[:user] = nil
    f[:info] = 'You are now logged out'
    redirect('/')
  end

end
