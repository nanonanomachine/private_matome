class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.boolean :private_flag
      t.integer :prev_content_id
      t.string :type
      t.string :title
      t.string :description
      t.string :search_keyword
      t.string :service_type
      t.string :source
      t.string :thumbnail_url
      t.string :url
      t.integer :list_id
      t.integer :user_id
      t.integer :group_id
      t.timestamp :updated_time

      t.timestamps
    end
  end
end
