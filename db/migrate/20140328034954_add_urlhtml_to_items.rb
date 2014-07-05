class AddUrlhtmlToItems < ActiveRecord::Migration
  def change
    add_column :items, :url_html, :string
  end
end
