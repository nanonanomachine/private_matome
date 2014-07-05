class RemoveUpdatedTimeToItems < ActiveRecord::Migration
  def change
    remove_column :items, :updated_time, :datetime
  end
end
