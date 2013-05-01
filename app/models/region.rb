class Region < ActiveRecord::Base
  attr_accessible :name, :query_code, :last_refresh

  has_many :restaurants

  def pull_restaurants
  	url = "http://nymag.com/srch?t=restaurant&N=265+336+#{self.query_code}&No=0&Ns=nyml_sort_name%7C0"
	doc = Nokogiri::HTML(open(url))
	doc.css(".result").each do |result|
		sleep(0.5)
		restaurant = Restaurant.new
		restaurant.name = result.css(".criticsPick a").text.strip
		restaurant.address = result.css(".address p").text.strip + ", New York City"
		restaurant.region_id = self.id
		restaurant.geocode
		restaurant.save
	end
  	url
  end

end
