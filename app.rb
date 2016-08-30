#!/usr/local/bin/ruby -rubygems

require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require 'dotenv'
require 'marvel_api'

Dotenv.load!

# Setup Marvel API configs
Client = Marvel::Client.new
Client.configure do |config|
  config.api_key     = ENV['MARVEL_PUBLIC_KEY']
  config.private_key = ENV['MARVEL_PRIVATE_KEY']
end

# Setup DataMapper
# ENV['DATABASE_URL']
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/streetbees.db")

# Comic Model
class Comic
  include DataMapper::Resource

  property :id, Serial
  property :title, String, required: true
  property :favourite, Boolean, default: false
  property :favourites_count, Integer, default: 0
  property :comic_id, String, required: true, index: true

  property :created_at, DateTime
  property :updated_at, DateTime
end

# Run the database migrations
DataMapper.auto_upgrade!

# Get all comics
# order(:release_date).asc
get '/' do
  if params[:search]
    @comics = Client.character(name: params[:search])
  else
    @comics = Client.comics
  end
  # puts @comics[0].to_json
  erb :index
end

# Search
# query using character
post '/' do
  comic = Client.character(params[:q])

  status 200
  format_response(comic, required.accept)
end

patch '/comics/:comic_id' do
  fav = Comic.where(comic_id: params[:comic_id])
  fav.favourites_count += 1
  if fav.save
    flash[:success] = 'Thats a success'
  else
    flash[:error] = 'There was a problem updating the fav-count'
  end
  redirect '/'
end

# Upvote a favourite comic
# We save it to the database because we love it
post '/upvote/:comic_id' do
  comic = Comic.get(params[:comic_id])
  if comic
    comic.favourite = true
  else
    c = Client.comic(params[:comic_id])
    comic = Comic.create(
              comic_id: c[0][:id],
              favourite: true,
              title: c[0][:title])
  end

  status 201
  format_response(comic, request.accept)
end

def format_response(data, accept)
  accept.each do |type|
    return data.to_xml  if type.downcase.eql? 'text/xml'
    return data.to_json if type.downcase.eql? 'application/json'
    return data.to_json
  end
end
