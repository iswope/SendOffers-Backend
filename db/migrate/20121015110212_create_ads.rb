class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :client_id
      t.integer :blast_id
      t.string :subject
      t.string :description
      t.string :supp_art
      t.string :dist_art
      t.date :start
      t.date :end
      t.date :blast_date
      t.string :status
      t.string :active
      t.string :imagemap
      t.string :admin_notes
      t.string :uuid
      
      t.timestamps
    end
  end
end
