class Region < ActiveRecord::Base
  attr_accessible :name, :query_code

  has_many :restaurants

  def pull_restaurants
  	url = "http://nymag.com/srch?t=restaurant&N=265+336+#{@query_code}&No=0&Ns=nyml_sort_name%7C0"
	doc = Nokogiri::HTML(open(url))
	binding.pry
	puts doc.at_css(".result").text
  end

end
puts doc.at_css('div:nth-child(1) :nth-child(1) a')