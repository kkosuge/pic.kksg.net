# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'mongoid'
gem "rmagick", :require => "RMagick"
require 'RMagick'
$:.unshift(File.dirname(__FILE__))
require 'models/image'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('pic')
end

def randstr(i=3)
  Array.new(i){(('a'..'z').to_a+('A'..'Z').to_a+('0'..'9').to_a)[rand(62)]}.join
end

def set_image(imagedata)
  file_name = "#{randstr}.png"
  file_path = "#{options.image_dir}/#{file_name}"

  File.open("#{file_path}","w").print(imagedata)
  image = Magick::Image.read("#{file_path}").first
  image.resize_to_fit!(200,200)
  image.write("#{options.image_dir}/thumb/#{file_name}")
 
  Image.create(file_name: "#{file_name}")

  "#{options.image_url}/#{file_name}"
end

configure do
  set :gyazo_id , 'sample'
  set :image_dir, 'public'
  set :image_url, 'http://pic.kksg.net'
end

get '/' do
  @images = Image.all.desc(:updated_at)
  haml :index
end

post '/upload/gyazo' do
  raise unless params['id'] == options.gyazo_id

  imagedata = params['imagedata'][:tempfile].read
  set_image(imagedata)
end

post '/tweetbot-upload' do
  imagedata = params['media'][:tempfile].read
  content_type :json
  { :url => set_image(imagedata) }.to_json
end
