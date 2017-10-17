class AddFlowIdToResponses < ActiveRecord::Migration[5.1]
  def change

    add_column :responses, :flow_id, :integer

  end
end
