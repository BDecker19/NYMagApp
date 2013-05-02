class Region < ActiveRecord::Base
  attr_accessible :name, :query_code, :last_refresh

  has_many :restaurants

  def self.pull_restaurants_all
  	# base_url = "http://nymag.com/srch?t=restaurant&N=265+336&No=0&Ns=nyml_sort_name%7C0"
  	base_url = "test.html"
	num_results = Region.find_number_results(base_url)
	num_pages = num_results
  end

  def self.find_number_results(base_url)
  	doc = Nokogiri::HTML(open(base_url))
	results_string = doc.css(".results").text.strip
	results = results_string.split[2].to_i
	results
  end


  def scrape_page(page_url)
	doc = Nokogiri::HTML(open(page_url))
	doc.css(".result").each do |result|
		sleep(0.05)
		restaurant = Restaurant.new
		restaurant.name = result.css(".criticsPick a").text.strip
		restaurant.address = result.css(".address p").text.strip + ", New York City"
		restaurant.region_id = self.id
		restaurant.geocode
		restaurant.save
	end
  end

end
