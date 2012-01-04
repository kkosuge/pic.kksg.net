require 'rubygems'
require 'sinatra'
$:.unshift(File.dirname(__FILE__))
require 'app'

run Sinatra::Application
