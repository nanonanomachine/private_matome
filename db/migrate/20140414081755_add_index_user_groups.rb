class AddIndexUserGroups < ActiveRecord::Migration
  def change
  	add_index :user_groups, [:group_id, :user_id]
  end
end
