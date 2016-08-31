# encoding: UTF-8

# Comic Model
class Comic
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,  required: true
  property :favourite,  Boolean, default: false
  property :comic_id,   String,  unique: true, index: true

  property :created_at, DateTime
  property :updated_at, DateTime
end
