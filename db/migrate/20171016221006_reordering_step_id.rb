class ReorderingStepId < ActiveRecord::Migration[5.1]
  def change
    def up
  change_column :responses, :step_id, :integer, after: :stage_id
end
  end
end
