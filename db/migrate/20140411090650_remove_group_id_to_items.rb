class RemoveGroupIdToItems < ActiveRecord::Migration
  def change
    remove_column :items, :group_id, :integer
  end
end
