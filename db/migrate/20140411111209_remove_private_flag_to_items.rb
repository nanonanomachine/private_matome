class RemovePrivateFlagToItems < ActiveRecord::Migration
  def change
    remove_column :items, :private_flag, :boolean
  end
end
