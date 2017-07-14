# Add your helpers here

module ApplicationHelpers

  # Return a user if we are logged in
  def current_user
    @user ||= App.db.users.first(s[:user]) if s[:user]
  end

end
