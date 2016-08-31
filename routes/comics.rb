# encoding: UTF-8

# Search comic characters
#
# POST: '/'
post '/characters' do
  if params[:q]
    comics = Client.character(name: params[:q])
  else
    comics = Client.comics
  end
  # puts comics[0].to_json
  json comics
end

# All favourite comics
#
# GET: '/favourites'
get '/favourites' do
  favourites = Comic.all

  json favourites
end

# Add comic to favourites
# by upvoting
#
# POST: '/comics/1234/upvote'
post '/comics/:id/upvote' do
  # comic = Comic.create(comic_id: params[:id], favourite: true)
  comic = Comic.try(comic_id: params[:id], favourite: true)

  status 201
  json comic
end

# Un-favourite a comic
put '/comics/:id/downvote' do
end

# Maybe its best to delete downvoted comics.
# No need to keep them around
delete '/comics/:id' do
  comic ||= Comic.get(comic_id: params[:id]) || halt(404)
  halt 500 unless comic.destroy
end
