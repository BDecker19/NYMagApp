class Coordinate < ActiveRecord::Base
  attr_accessible :latitude, :longitude

  belongs_to :restaurant

end
