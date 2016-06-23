class AddUserIdToCrawlers < ActiveRecord::Migration[5.0]
  def change
  	add_column :crawlers, :user_id, :integer
  	add_index :crawlers, :user_id
  end
end
