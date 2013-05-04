class Region < ActiveRecord::Base
  attr_accessible :name, :last_refresh

  has_many :restaurants

  def self.pull_restaurants
  	base_url = "http://nymag.com/srch?t=restaurant&N=265+336+69&No=0&Ns=nyml_sort_name%7C0"  # full critics pick query listing
	num_results = Region.find_number_results(base_url)
	num_pages = (num_results/25)+1  #int division gives floor by default
	for i in 0...num_pages
		page_url = "http://nymag.com/srch?t=restaurant&N=265+336+69&No=#{(i*25)+1}&Ns=nyml_sort_name%7C0"
		Region.scrape_page(page_url)
	end
  end

  def self.find_number_results(base_url)
  	doc = Nokogiri::HTML(open(base_url))
	results_string = doc.css(".results").text.strip
	results = results_string.split[2].to_i
	results
  end


  def self.scrape_page(page_url)
	doc = Nokogiri::HTML(open(page_url))
	doc.css("#resultsFound tr")[1..25].each do |result|
		restaurant = Restaurant.new
		restaurant.name = result.css(".criticsPick a").text.strip
		restaurant.address = result.css(".address p").text.strip.split(',')[0]
		region = result.css("td")[3].css("p").text
		region_lookup = Region.find_by_name(region)
		if region_lookup
			restaurant.region_id = region_lookup.id
		else
			new_region = Region.new
			new_region.name = region
			new_region.save
			restaurant.region_id = new_region.id
		end
		restaurant.geo_query = "#{restaurant.name}, #{restaurant.address}, New York City"
		restaurant.geocode
		restaurant.save
		sleep(0.1)
	end
  end

end