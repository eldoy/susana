# User validations

module UserValidations

  # Used when creating a user
  def user_validation
    e.add(:email, 'already taken') if App.db.users.first(:email => p[:email])
    e.add(:email, 'not valid') if p[:email] !~ App.regex.email
    e.add(:password, 'too short') if p[:password].size < 2
    e.add(:confirm, 'not equal to password') if p[:confirm] != p[:password]
  end

end
