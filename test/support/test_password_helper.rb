require "bcrypt"

module TestPasswordHelper

  def default_password_digest(password)
    BCrypt::Password.create(password)
  end
end