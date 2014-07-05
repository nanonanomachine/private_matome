class RemoveEyecatchToLists < ActiveRecord::Migration
  def change
    remove_column :lists, :eyecatch, :string
  end
end
