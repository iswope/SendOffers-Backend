class Client < ActiveRecord::Base

  belongs_to :user
  
  attr_accessible :admin_notes, :company, :created_at, :email, :fax, :firstname, :lastname, :mailing_address, :mailing_address2, :mailing_city, :mailing_country, :mailing_state, :mailing_zip, :phone, :shipping_address, :shipping_address2, :shipping_city, :shipping_country, :shipping_state, :shipping_zip, :status, :updated_at, :web, :leadname, :leademail
  
end
