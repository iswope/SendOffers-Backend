class AddContentToAds < ActiveRecord::Migration
  def change
    add_column :ads, :content, :string
  end
end
