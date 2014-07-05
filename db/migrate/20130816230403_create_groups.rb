class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :link
      t.string :privacy
      t.timestamp :updated_time

      t.timestamps
    end
  end
end
