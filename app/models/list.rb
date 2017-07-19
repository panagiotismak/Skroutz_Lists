class List < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, length: {minimum: 3, maximun: 50}
  validates :user_id, presence: true

  scope :visible, -> {where(private: false)}
end