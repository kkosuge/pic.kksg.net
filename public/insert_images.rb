require 'pp'
require 'json'
require 'mongoid'
$:.unshift(File.dirname(__FILE__))
require '../models/image'

@images = Dir::entries(options.image_dir)
@images.reject! {|f| /\.(:?jpe?g|png)/ !~ f }
@images.each do |image|
Image.create(:file_name => image)
end
