class ListVote < ActiveRecord::Base
  belongs_to :list, counter_cache: :votes_count
  belongs_to :user

  validates :list, uniqueness: {scope: :user} 
end