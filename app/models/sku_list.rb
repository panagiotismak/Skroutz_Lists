class SkuList < ActiveRecord::Base
  belongs_to :list

  validates :sku_id, uniqueness: {scope: :list} 
end