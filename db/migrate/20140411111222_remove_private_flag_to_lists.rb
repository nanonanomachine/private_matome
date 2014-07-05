class RemovePrivateFlagToLists < ActiveRecord::Migration
  def change
    remove_column :lists, :private_flag, :boolean
  end
end
