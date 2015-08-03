require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'
require 'rack'

require 'sinatra'

get '/' do
  @properties = all_together_now
  erb :index
end


get '/the_goods.json' do
  all_together_now.to_json
end






def index
  url = "http://www.zoopla.co.uk/for-sale/property/london/mattison-road/n4-1bq/?q=n4%201bq&category=residential&include_shared_accommodation=&keywords=&radius=0&added=&price_min=&price_max=500000&beds_min=&beds_max=&include_retirement_homes=true&include_shared_ownership=true&new_homes=include&polyenc=yruyHv%7DGgxAtzAem%40lbAcJeSsG%60gEhDxk%40i%40NnDz%40rDO~FgBzFeFbMIzH%7DAxBcD~%40oFzdAfn%40hVc%7DBkHwj%40%7Cc%40bR&search_source=refine&user_alert_id=5495743"
  doc = Nokogiri::HTML(open(url))
  links = []
  doc.css('a:contains("Full details")').each do |link|
    links.push("http://www.zoopla.co.uk" +link['href'])
  end
  links
end


def show(url)
  doc           = Nokogiri::HTML(open(URI.escape(url)))
  images        = []
  lat_lng       = ""
  google        =
  doc.css('.images-thumb').each do |image|
    src = image['data-photo']
    images.push(src)
  end
  {:images => images, :lat_lng => "", :url => "", :google => ""}
end

def lat_long(uri)
  env = Rack::MockRequest.env_for(uri)
  req = Rack::Request.new(env)
  req.params['center']
end

def all_together_now
  json = []
  index.each do |link|
    json.push(show(link))
  end
  json
end


