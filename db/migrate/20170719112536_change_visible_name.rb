class ChangeVisibleName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :lists, :visible, :private
  end
end
