class AddReachmailgroupIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :reachmailgroup_id, :string
  end
end
