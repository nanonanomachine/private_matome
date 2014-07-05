class RemoveThumbnailUrlToItems < ActiveRecord::Migration
  def change
    remove_column :items, :thumbnail_url, :string
  end
end
