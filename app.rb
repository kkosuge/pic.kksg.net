require 'rubygems'
require 'sinatra'
require 'digest/md5'
require 'rack'
require 'haml'
require 'sdbm'
#TODO require 'active_record'


#class Gyazo < Sinatra::Base

  configure do
    set :gyazo_id, ''
    set :image_dir, 'public/images'
    set :image_url, 'http://pic.kksg.net'
  end

  get '/:id' do
    send_file "#{options.image_dir}/#{params[:id]}",
      :type => 'image/png',
      :disposition => 'inline'
  end

  get '/' do
    images = Dir::entries(options.image_dir)
    @images = images.sort_by{rand}[0..10]
    haml :index
  end

  post '/upload/gyazo' do
    raise unless request[:id] == options.gyazo_id
    imagedata = params['imagedata'][:tempfile].read
    hash = Digest::MD5.hexdigest(imagedata)[0..2]
    File.open("#{options.image_dir}/#{hash}.png","w").print(imagedata)
    "http://#{options.image_url}/#{hash}.png"
  end
#end
