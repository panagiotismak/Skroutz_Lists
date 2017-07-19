class SetDefaultValueToListsPrivate < ActiveRecord::Migration[5.1]
  def change
  	change_column :lists, :private, :boolean, default: false
  end
end
