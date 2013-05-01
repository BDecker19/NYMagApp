class Region < ActiveRecord::Base
  attr_accessible :name, :query_code

  has_many :restaurants

  def self.pull_restaurants
  	url = "http://nymag.com/srch?t=restaurant&N=265+336&No=0&Ns=nyml_sort_name%7C0"
	doc = Nokogiri::HTML(open(url))
	binding.pry
	doc.css(".result .criticsPick a").each do |result|
		result.text
	end
	puts doc.at_css(".result").text
  end

end

 doc.css(".result .criticsPick a")[1].text