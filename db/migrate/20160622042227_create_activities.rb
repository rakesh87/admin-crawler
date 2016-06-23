class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :crawler_id
      t.string :source_name
      t.integer :fields_data_number

      t.timestamps
    end
    add_index :activities, :crawler_id
  end
end
