# encoding: UTF-8

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

RSpec.describe Sinatra::Application do
  describe 'GET "/"' do
    context 'when I visit home page' do
      it 'It should be successful' do
        get '/'

        expect(last_response).to be_ok
      end

      it 'I should see a search-form' do
        get '/'

        expect(last_response.body).to match('<form class="uk-search')
      end
      it 'I should see a list of comics' do
        get '/'

        expect(last_response.body).to match('<figure')
      end

      it 'I should see pagination links' do
        get '/'

        expect(last_response.body).to match('<ul class="uk-pagination ')
      end
    end

    context 'when I search for a comic character' do
      # let(:params) { Hash[q: 'hulk'] }

      it 'with a valid name, I should see a comic characters' do
        post '/search?q=hulk'

        # puts last_response
        expect(last_response.body).not_to be_empty
      end

      it 'with an invalid name, I should see empty page' do
        post '/search?q=nothulk'

        # puts last_response.to_json
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(404)
      end
    end

    context 'Favourite comics' do
      arr = []

      it 'should be a success' do
        get '/favourites'

        arr = JSON.parse(last_response.body)
        expect(arr).not_to be(Array)
      end

      # it 'I should see it in my favourite comics' do
      #   get '/favourites'
      #
      #   expect(last_response.body.to_a).to be(Array)
      # end
      #
      # it 'I should see my favourite comics' do
      #   delete '/favourites/12345'
      # end
    end
  end
end
