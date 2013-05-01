class Region < ActiveRecord::Base
  attr_accessible :name, :query_code, 

  has_many :restaurants


end
