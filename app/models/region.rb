class Region < ActiveRecord::Base
  attr_accessible :name, :last_refresh, :query_code

  has_many :restaurants

  def self.pull_restaurants(region_code = "")
  	# defaults to all if no code specified -- kinda hacked for now to accomodate both region and all regions pull
  	base_url = "http://nymag.com/srch?t=restaurant&N=265+336+#{region_code}&No=0&Ns=nyml_sort_name%7C0"  # full critics pick query listing
	num_results = Region.find_number_results(base_url)
	num_pages = (num_results/25)+1  #int division gives floor by default
	for i in 0...num_pages
		page_url = "http://nymag.com/srch?t=restaurant&N=265+336+#{region_code}&No=#{(i*25)+1}&Ns=nyml_sort_name%7C0"
		Region.scrape_page(page_url)
	end
  end

  def self.find_number_results(base_url)
  	doc = Nokogiri::HTML(open(base_url))
	results_string = doc.css(".results").text.strip
	# results = results_string.split[2].to_i
	results = 25;  # for testing
	results
  end


  def self.scrape_page(page_url)
	doc = Nokogiri::HTML(open(page_url))
	doc.css("#resultsFound tr")[1..25].each do |result|
		restaurant = Restaurant.new
		restaurant.name = result.css(".criticsPick a").text.strip
		
		# address
		address_string = result.css(".address p").text.strip.split(',')[0]
		if address_string.include?("nr.")
			nr_index = address_string.split.index("nr.")
			address_string = address_string.split[0...nr_index].join # everything before the "nr." 
		end
		
		if address_string.include?("fl.")
			address_string = address_string.split[0...-2].join # exclude the last 2 words
		end
		restaurant.address = address_string
		
		#region
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
		restaurant.geo_query = "#{restaurant.address}, Manhattan"
		restaurant.geocode
		restaurant.save
		sleep(0.3)
	end
  end

end