class Ad < ActiveRecord::Base
  attr_accessible :active, :blast_id, :client_id, :dist_art, :end, :imagemap, :start, :subject, :subject_line, :supp_art
end
