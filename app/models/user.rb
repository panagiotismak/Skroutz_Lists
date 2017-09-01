class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

  has_many :lists, dependent: :destroy
  has_many :list_votes
  has_many :vote_lists, through: :list_votes, source: :list

  before_save { self.email = email.downcase }

  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
            length: { in: 3..25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false}, 
            length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 8 }, on: :create
end	