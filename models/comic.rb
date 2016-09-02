# encoding: UTF-8

# Comic Model
class Comic
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :favourite,  Boolean, default: false
  property :comic_id,   String,  unique: true, index: true

  property :created_at, DateTime
  property :updated_at, DateTime

  def self.call(par)
    first_or_create(comic_id: par)
    # create(comic_id: par, favourite: true) || get(comic_id: par)
  end
end
