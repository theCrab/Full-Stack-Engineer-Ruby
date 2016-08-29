require 'rubygems'
require 'sinatra'
require 'marvel_api'

Client = Marvel::Client.new

Client.configure do |config|
  config.api_key     = '962d5f16d7ac13fb8193c585d14ee2c0'
  config.private_key = 'a67b0a227d0e9334ebca703336b374e14e039d6b'
end

# Get all comics
# order(:release_date).asc
get '/' do
  # @comics = Client.comics
  # puts @comics.last.to_json
  erb :index
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

def search(ps)
  @client.comics(title: ps[:search])
end
