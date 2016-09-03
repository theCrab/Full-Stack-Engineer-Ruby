# encoding: UTF-8

# Search comic characters
#
# POST: '/'
post '/search' do
  cs = params[:q].empty? ? Client.comics : Client.characters(name: params[:q])
  halt 404 if cs.size == 0

  format_response(cs, request.accept)
end

# All favourite comics
#
# GET: '/favourites'
get '/favourites' do
  favourites = Comic.all.map(&:comic_id)
  # puts "Line 17: #{favourites}"
  format_response(favourites, request.accept)
end

# Add comic to favourites
# by upvoting
#
# POST: '/comics/1234/upvote'
post '/comics/:id/upvote' do
  # body = JSON.parse request.body.read
  comic = Comic.call(params[:id])

  format_response(comic, request.accept)
end

# Un-favourite a comic
# put '/comics/:id/downvote' do
# end

# Maybe its best to delete downvoted comics.
# No need to keep them around
delete '/comics/:id/downvote' do
  comic = Comic.first(comic_id: params[:id])
  return status 410 if delete_from_db(comic)

  # format_response(comic, request.accept)
end

# Better to move this to a helper
def format_response(data, accept)
  accept.each do |type|
    # return data.to_xml  if type.downcase.eql? 'text/xml'
    return data.to_json if type.downcase.casecmp('application/json')
    return data.to_json
  end
end

# delete the comic
def delete_from_db(comic)
  true if comic.destroy
end
