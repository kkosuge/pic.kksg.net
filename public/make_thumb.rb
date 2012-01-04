require 'rubygems'
require 'RMagick' 

width = 200
height = 200

Dir.mkdir("./thumb") unless Dir.exist?("./thumb")
files = Dir.entries("./")

files.each_with_index do |file,index|
  puts "#{index+1}/#{files.size}"
  if file !~ /^\./ && file =~ /\.(:?jpe?g|png)/
    begin
      image = Magick::Image.read(file).first
      image.resize_to_fit!(width,height)
      image.write("./thumb/#{file}")
    rescue => e
      puts e
    end
  end
end
