class CreateLogsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|

      t.integer :message_id
      t.integer :user_id
      t.integer :flow_id
      t.integer :intent_id
      t.text :raw_message
      t.boolean :has_attachment
      t.timestamps

    end
  end
end
