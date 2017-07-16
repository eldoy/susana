# User validations

module UserValidations

  # Used when creating a user
  def user_validation
    email_validation
    password_validation
  end

  # Validate password
  def password_validation
    e.add(:password, 'too short') if p[:password].size < 2
    e.add(:confirm, 'not equal to password') if p[:confirm] != p[:password]
  end

  # Validate email
  def email_validation
    e.add(:email, 'already taken') if db.users.first(:email => p[:email])
    e.add(:email, 'not valid') if p[:email] !~ regex.email
  end

  # Validate current password
  def current_password_validation
    e.add(:cpassword, 'is incorrect') unless authenticate(current_user, p[:cpassword])
  end

end
