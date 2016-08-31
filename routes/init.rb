# encoding: UTF-8

require_relative './comics'

# All common routes are contained here
#
# Home page
# GET: '/'
get '/' do
  @comics = Client.comics

  erb :index
end

# About page
# GET: '/about'
# get '/about' do
# end
