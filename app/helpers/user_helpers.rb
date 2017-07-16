# Helpers for the users

module UserHelpers

  # Return a user if we are logged in
  def current_user
    @current_user ||= db.users.first(:token => s[:user]) if s[:user]
  end

  # Authenticate user
  def authenticate(user, pw = p[:password])
    user and user.password == BCrypt::Engine.hash_secret(pw, user.salt)
  end

  # Generate a token and make sure it's unique
  def generate_token(coll, field = :token)
    begin
      token = SecureRandom.urlsafe_base64
    end while db.send(coll).first(field => token)
    token
  end

end
