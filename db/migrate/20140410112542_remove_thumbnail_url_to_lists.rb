class RemoveThumbnailUrlToLists < ActiveRecord::Migration
  def change
    remove_column :lists, :thumbnail_url, :string
  end
end
