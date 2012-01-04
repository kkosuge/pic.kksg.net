require 'pp'
require 'json'
require 'mongoid'
$:.unshift(File.dirname(__FILE__))
require '../models/image'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('pic')
end

@images = Dir::entries('./')

@images.reject! {|f| /\.(:?jpe?g|png)/ !~ f }
@images.each do |image|
  Image.create(:file_name => image)
end
