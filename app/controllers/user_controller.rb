class UserController < ApplicationController

  # GET /signup
  def signup
    @user = User.new
    erb('user/signup', :layout => :default)
  end

  # POST /create
  def create
    # Set up user
    @user = User.new(p)
    @user.password = p[:password]
    @user.confirm = p[:confirm]
    @user.salt = BCrypt::Engine.generate_salt
    @user.pw = BCrypt::Engine.hash_secret(@user.password, @user.salt)
    @user.token = Susana::Util.generate_token(:users)
    @user.validate_email = true
    @user.validate_password = true

    if @user.save(:validate => true)
      # Send hello email
      # mail.hello

      # Log in and redirect
      s[:user] = @user.token
      f[:info] = 'Welcome to Susana!'
      redirect('/')
    else
      f.now[:error] = 'Please correct the errors below'
      erb('user/signup', :layout => :default)
    end
  end

  # GET /login
  def login
    erb('user/login', :layout => :default)
  end

  # POST /session
  def session
    # Check if user is in database
    @user = User.first(:email => p[:email])

    # Authenticate user
    if @user and @user.authenticate(p[:password])
      # Log in user
      s[:user] = @user.token
      f[:info] = 'Welcome back!'
      redirect(p[:redirect].present? ? p[:redirect] : '/')
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
    @user = current_user
    erb('user/settings', :layout => :default)
  end

  # PUT /update
  def update

    # Fetch user
    @user = current_user
    @user.email = p[:email]
    @user.validate_email = true

    # Update user
    if @user.save(:validate => true)
      f[:info] = 'Settings updated'
      redirect('/settings')
    else
      f.now[:error] = 'Please correct the errors below'
      erb('user/settings', :layout => :default)
    end
  end

  # PUT /password
  def password

    # Fetch user
    @user = current_user

    # Set up password
    @user.password = p[:password]
    @user.confirm = p[:confirm]
    @user.current_password = p[:current_password]
    @user.pw = BCrypt::Engine.hash_secret(@user.password, @user.salt)
    @user.validate_password = true
    @user.validate_current_password = true

    # Save or display error
    if @user.save(:validate => true)
      f[:info] = 'Password updated'
      redirect('/settings')
    else
      f.now[:error] = 'Please correct the errors below'
      erb('user/settings', :layout => :default)
    end
  end

end
