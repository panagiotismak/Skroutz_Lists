class CreateSkuLists < ActiveRecord::Migration[5.1]
  def change
    create_table :sku_lists do |t|
      t.timestamps
      t.integer :sku_id
      t.references :list, null: false
    end
  end
end
