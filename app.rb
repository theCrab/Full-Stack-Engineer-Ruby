#!/usr/local/bin/ruby -rubygems

# NOTE: To run tests `bundle exec rspec rake_spec.rb -f doc`
# NOTE: To run app `bundle exec rackup`

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
configure :development, :test do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(
    :default,
    "sqlite://#{Dir.pwd}/db/streetbees.db"
  )
end

# Models
require './models/init'
require './routes/init'

# Check the integrity of the models
DataMapper.finalize
