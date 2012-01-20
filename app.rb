# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
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

def randstr(i=3)
  Array.new(i){(('a'..'z').to_a+('A'..'Z').to_a+('0'..'9').to_a)[rand(62)]}.join
end

def gen_file_name
  name = randstr
  while Image.exists?(conditions: { file_name: name })
    name = randstr
  end
  name
end

def set_image(imagedata)
  file_name = "#{gen_file_name}.png"
  file_path = "#{options.image_dir}/#{file_name}"
  File.open("#{file_path}","w").print(imagedata)
  Image.create(file_name: "#{file_name}")

  "#{options.image_url}/#{file_name}"
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
