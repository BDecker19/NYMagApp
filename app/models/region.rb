class Region < ActiveRecord::Base
  attr_accessible :name, :query_code

  has_many :restaurants

  def pull_restaurants(region_id)
  	url = "http://nymag.com/srch?t=restaurant&N=265+336+#{@query_code}&No=0&Ns=nyml_sort_name%7C0"
	doc = Nokogiri::HTML(open(url))
	doc.css(".result").each do |result|
		restaurant = Restaurant.new
		restaurant.name = result.css(".criticsPick a").text.strip
		restaurant.address = result.css(".address p").text.strip + ", New York City"
		restaurant.region_id = region_id
		restaurant.geocode
		restaurant.save
	end
	binding.pry
  end

end

 # doc.css(".result .criticsPick a")[1].text
 # puts doc.at_css(".result").text