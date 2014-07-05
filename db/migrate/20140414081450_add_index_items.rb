class AddIndexItems < ActiveRecord::Migration
  def change
  	add_index :items, [:list_id, :user_id]
  end
end
