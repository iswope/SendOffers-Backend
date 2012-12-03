class CreateReachmailgroups < ActiveRecord::Migration
  def change
    create_table :reachmailgroups do |t|
      t.integer :client_id
      t.string :name
      t.string :groupid

    end
  end
end
