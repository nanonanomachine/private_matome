class AddIdsToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :user_id, :integer
    add_column :user_groups, :group_id, :integer
  end
end
