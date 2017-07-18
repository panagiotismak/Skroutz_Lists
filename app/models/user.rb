class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :lists, dependent: :destroy

  before_save { self.email = email.downcase }

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
            length: { minimum: 3, maximun: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false}, 
            length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum:8, maximum: 100}
end	