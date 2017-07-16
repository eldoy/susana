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
      # Generate salt, hashed password and token for security
      salt = BCrypt::Engine.generate_salt
      password = BCrypt::Engine.hash_secret(p[:password], salt)
      token = generate_token(:users)

      # Store in database
      App.db.users.set(:email => p[:email], :salt => salt, :password => password, :token => token)

      # Log in and redirect
      s[:user] = token
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
    # Check if user is in database
    user = App.db.users.first(:email => p[:email])

    # Authenticate user
    if authenticate(user)
      # Log in user
      s[:user] = user.token
      f[:info] = 'Welcome back!'
      redirect(p[:redirect] || '/')
    else
      f.now[:error] = 'Email and password combination not found'
      erb('user/login', :layout => :default)
    end
  end

  # GET /logout
  def logout
    s[:user] = nil
    f[:info] = 'You are now logged out'
    redirect('/')
  end

  # GET /settings
  def settings
    require_user_login
    erb('user/settings', :layout => :default)
  end

  # PUT /update
  def update
    require_user_login
    email_validation

    # Save or display error
    if e.any?
      f.now[:error] = 'Please correct the errors below'
      erb('user/settings', :layout => :default)
    else
      # Save in db
      App.db.users.set(current_user.id, :email => p[:email])
      f[:info] = 'Settings updated'
      redirect('/settings')
    end
  end

  # PUT /password
  def password
    require_user_login
    password_validation
    current_password_validation

    # Save or display error
    if e.any?
      f.now[:error] = 'Please correct the errors below'
      erb('user/settings', :layout => :default)
    else
      # Generate new hashed password
      password = BCrypt::Engine.hash_secret(p[:password], current_user.salt)

      # Store new password
      App.db.users.set(current_user.id, :password => password)
      f[:info] = 'Password updated'
      erb('user/settings', :layout => :default)
    end
  end

end
