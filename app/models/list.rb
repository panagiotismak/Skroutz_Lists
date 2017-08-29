require 'skroutzapi'
class List < ActiveRecord::Base
  belongs_to :user
  has_many :sku_lists
  has_many :list_votes
  has_many :vote_users, through: :list_votes, source: :user

  validates :name, presence: true, uniqueness: {scope: :user, case_sensitive: false}, length: {minimum: 3, maximun: 50}
  validates :user_id, presence: true

  scope :visible, -> {where(private: false)}

  def list_total_price()
  	skroutz=Skroutzapi.new
    list_price = 0
    self.sku_lists.pluck(:sku_id).each do |variable|
      list_price +=  skroutz.search_sku_by_id(variable).price_min
    end
    list_price.round(2)
  end
end 