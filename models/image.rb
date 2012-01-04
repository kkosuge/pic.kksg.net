# coding: utf-8
class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_names, type: String
end

