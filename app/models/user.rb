class User
  include Mongocore::Document

  # Validations
  validate do

    # Validate email
    if validate_email
      errors[:email] << 'not valid' if email !~ App.regex.email
      errors[:email] << 'already taken' if User.first(:email => email)
    end

    # Validate password and confirmation
    if validate_password
      errors[:password] << 'too short' if password.size < 2
      errors[:confirm] << 'not equal to password' if confirm != password
    end

    # Validate current password
    errors[:current_password] << 'is incorrect' if validate_current_password and authenticate(current_password)
  end

  # Authenticate user
  def authenticate(pword)
    pw == BCrypt::Engine.hash_secret(pword, salt)
  end

end
