class Restaurant < ActiveRecord::Base
 	attr_accessible :address, :name

	has_one :coordinate
	belongs_to :region

	validates :address, :presence => true

 	geocoded_by :address, :latitude  => :lat, :longitude => :lon
  

    after_validation :geocode

end
