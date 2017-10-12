# Helpers for the users

module UserHelpers

  # Return a user if we are logged in
  def current_user
    @current_user ||= User.first(:token => s[:user]) if s[:user]
  end

end
