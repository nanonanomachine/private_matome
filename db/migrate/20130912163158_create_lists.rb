class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.boolean :draft_flag
      t.boolean :private_flag
      t.string :title
      t.string :description
      t.string :thumbnail_url
      t.integer :user_id
      t.integer :group_id
      t.timestamp :updated_time

      t.timestamps
    end
  end
end
