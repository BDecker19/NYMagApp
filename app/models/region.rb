class Region < ActiveRecord::Base
  attr_accessible :name, :query_code, :last_refresh

  has_many :restaurants

  def self.pull_restaurants_all
  	base_url = "http://nymag.com/srch?t=restaurant&N=265+336&No=0&Ns=nyml_sort_name%7C0"  # full critics pick query listing
	num_results = Region.find_number_results(base_url)
	num_pages = (num_results/25)+1  #int division gives floor by default
	for i in 0...num_pages
		page_url = "http://nymag.com/srch?t=restaurant&N=265+336&No=#{(i*25)+1}&Ns=nyml_sort_name%7C0"
		scrape_page(page_url)
	end
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
		restaurant.address = result.css(".address p").text.strip
		region  = 
		restaurant.region_id = self.id
		restaurant.geo_query "#{restaurant.name}, #{restaurant.address}, New York City"
		restaurant.geocode
		binding.pry
		# restaurant.save
	end
  end

end
