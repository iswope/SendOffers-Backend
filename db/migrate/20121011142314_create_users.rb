class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.string :role
      t.string :sopass
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
