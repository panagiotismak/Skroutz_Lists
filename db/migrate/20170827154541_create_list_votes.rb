class CreateListVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :list_votes do |t|
      t.timestamps
      t.references :list, null: false
      t.references :user, null: false
    end
  end
end
