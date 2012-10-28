class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :user_id
      t.string :role
      t.string :email
      t.string :company
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :fax
      t.string :mailing_address
      t.string :mailing_address2
      t.string :mailing_city
      t.string :mailing_state
      t.string :mailing_zip
      t.string :mailing_country
      t.string :shipping_address
      t.string :shipping_address2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_zip
      t.string :shipping_country
      t.string :web
      t.string :admin_notes
      t.string :leadname
      t.string :leademail
      t.string :status
      t.string :uuid
      t.datetime :created_at
      t.datetime :updated_at

    end
  end
end
