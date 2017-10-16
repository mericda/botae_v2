class RemoveResponsesIdColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :responses, :id
  end
end
