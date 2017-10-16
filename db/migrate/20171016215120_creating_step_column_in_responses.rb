class CreatingStepColumnInResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :step_id, :integer
  end
end
  
