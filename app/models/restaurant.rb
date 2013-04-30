class Restaurant < ActiveRecord::Base
 	attr_accessible :address, :name, :lat, :long

	has_one :coordinate
	belongs_to :region

	validates :address, :presence => true

 	geocoded_by :address, :latitude  => :lat, :longitude => :long
  

    after_validation :geocode

end
