require 'rubygems'
require 'sinatra'
require 'bundler'
Bundler.require
$:.unshift(File.dirname(__FILE__))
require 'app'

run Sinatra::Application
