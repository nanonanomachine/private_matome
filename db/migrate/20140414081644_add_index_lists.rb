class AddIndexLists < ActiveRecord::Migration
  def change
  	add_index :lists, [:user_id, :group_id]
  end
end
