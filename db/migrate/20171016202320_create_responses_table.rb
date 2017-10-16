class CreateResponsesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.integer :response_id
      t.integer :stage_id
      t.text :response_content
    end
  end
end
