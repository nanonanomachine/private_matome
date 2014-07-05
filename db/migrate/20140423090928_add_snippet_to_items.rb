class AddSnippetToItems < ActiveRecord::Migration
  def change
    add_column :items, :snippet, :string
  end
end
