class Ad < ActiveRecord::Base
  attr_accessible :active, :blast_id, :client_id, :dist_art, :supp_art, :end, :imagemap, :start, :subject, :subject_line, :supp_art, :blast_date, :blast_date, :blast_date, :description, :company, :email, :web
  
  belongs_to :client
  
  mount_uploader  :dist_art, ArtUploader
  mount_uploader :supp_art, ArtUploader
  
  
  
end