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
  end
end
