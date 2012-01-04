# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'digest/md5'
require 'haml'
require 'sdbm'
require 'pp'
require 'json'
require 'mongoid'
$:.unshift(File.dirname(__FILE__))
require 'models/image'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('pic')
end

configure do
  set :gyazo_id , 'sample'
  set :image_dir, 'public'
  set :image_url, 'http://pic.kksg.net'
end

get '/images.json' do
  content_type :json
  images = []
  Image.all.each {|i| images << i.file_name}
  JSON.unparse(images: images)
end

get '/' do
  @images = Image.all
  haml :index
end

post '/upload/gyazo' do
  raise unless params['id'] == options.gyazo_id

  imagedata = params['imagedata'][:tempfile].read
  hash = Digest::MD5.hexdigest(imagedata)[0..2]
  file_name = "#{hash}.png"
  file_path = "#{options.image_dir}/#{file_name}"

  File.open("#{file_path}","w").print(imagedata)
  image = Magick::Image.read("#{file_path}").first
  image.resize_to_fit!(200,200)
  image.write("#{options.image_dir}/thumb/#{file_name}")
 
  Image.create(file_name: "#{file_name}")

  "#{options.image_url}/#{file_name}"
end
