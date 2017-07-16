# Add your filters here

module ApplicationFilters

  # Check if user is logged in and redirects to login
  def require_user_login
    unless current_user
      f[:error] = 'Login required'
      redirect("/login?redirect=#{path_info}")
    end
  end

end
