class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :client_id
      t.integer :blast_id
      t.date :blast_date
      t.string :description
      t.string :supp_art
      t.string :dist_art
      t.integer :active
      t.date :start
      t.date :end
      t.string :status
      t.string :subject_line
      t.string :imagemap

      t.timestamps
    end
  end
end
