class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :username, uniqueness: { case_sensitive: false }, 
                       presence: true,
                       length: { in: 4..16 },
                       format: { with: /\A[a-zA-Z0-9_\u4e00-\u9fa5]+\z/, message: 'Username cannot contain special characters ' }
  validates :password, presence: true,
                       length: { in: 8..16 },
                       format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\S]{8,16}\z/, message: 'Password need to consists of uppercase letters, lowercase letters and numbers' }

  def remember_token
    [id, Digest::SHA512.hexdigest(password_digest)].join('$')
  end

  def self.find_by_remember_token(token)
    user = find_by_id(token.split('$').first)
    (user && Rack::Utils.secure_compare(user.remember_token, token)) ? user : nil 
  end
end