class Restaurant < ActiveRecord::Base
 	attr_accessible :address, :name, :geo_query, :region_id, :lat, :long

	has_one :coordinate
	belongs_to :region

	validates :name, :presence => true
	validates :address, :presence => true

 	geocoded_by :geo_query, :latitude  => :lat, :longitude => :long
  

    after_validation :geocode

end