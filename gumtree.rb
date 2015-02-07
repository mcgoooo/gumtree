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
  url = "http://www.gumtree.com/1-bedroom-rent/hackney"
  doc = Nokogiri::HTML(open(url))
  links = []
  doc.css('a.listing-link').each do |link|
    links.push("http://www.gumtree.com" + link['href'])
  end
  links
end


def show(url)
  doc           = Nokogiri::HTML(open(URI.escape(url)))
  images        = []
  lat_lng       = ""
  google        =
  doc.css('#vip-tabs-images img').each do |image|
    src = image['data-lazy']
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


