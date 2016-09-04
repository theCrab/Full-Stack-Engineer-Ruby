# encoding: UTF-8

# NOTE: To run tests `bundle exec rspec rake_spec.rb -f doc`
# NOTE: To run app `bundle exec rackup`

require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require './app'

# RSpecMixin namespace
module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  # config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

RSpec.describe 'SBMarvel' do
  describe 'GET "/"' do
    context 'when I visit home page' do
      let(:action) { get '/' }

      it 'It should be successful' do
        expect(action).to be_ok
      end

      it 'I should see a search-form' do
        expect(action.body).to match('<form class="uk-search')
      end
      it 'I should see a list of comics' do
        expect(action.body).to match('<figure')
      end

      it 'I should see pagination links' do
        expect(action.body).to match('<ul class="uk-pagination ')
      end
    end

    context 'POST comic character' do
      let(:params) { Hash[q: 'hulk'] }

      it 'with a valid name, I should see a comic characters' do
        post '/search', params

        expect(last_response.body).not_to be_empty
      end

      it 'with an invalid name, I should see empty page' do
        post '/search', q: 'nothulk'

        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(404)
      end
    end

    context 'Favourite comics' do
      let(:favourites) { get '/favourites' }
      let(:result) { JSON.parse(favourites.body) }

      it 'GET should be successful' do
        expect(favourites.status).to eq(200)
        expect(result).to be_kind_of(Array)
      end

      it 'POST should be successful' do
        # let(:upvote) {
        post "/comics/#{result.first}/upvote"
        # , id: result.first # '/favourites?id="12345"'
        expect(last_response.status).to eq(200)

        get '/favourites'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to include(result.first)
      end

      it 'DELETE should be successful' do
        # delete "/favourites/#{result.first}"
        delete "/comics/#{result.pop}/downvote"
        expect(last_response.status).to eq(410)
      end
    end
  end
end
