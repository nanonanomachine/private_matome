class RemoveSearchKeywordToItems < ActiveRecord::Migration
  def change
    remove_column :items, :search_keyword, :string
  end
end
