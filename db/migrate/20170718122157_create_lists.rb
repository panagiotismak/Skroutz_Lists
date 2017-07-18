class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.timestamps
      t.string :name
      t.boolean :visible
      t.integer :votes_count
      t.float :total_price
      t.references :user, null: false
    end
  end
end
