require 'sinatra'
require 'json'
require 'webrick'

set :server, 'webrick'

# Load quotes from the JSON file
quotes = JSON.parse(File.read('quotes.json'))

# Endpoint to retrieve all quotes
get '/quotes' do
  content_type :json
  quotes.to_json
end

# Endpoint to retrieve a specific quote by index
get '/quotes/:index' do
  index = params[:index].to_i
  halt 404, { error: 'Index out of bounds' }.to_json unless index.between?(0, quotes.length - 1)
  content_type :json
  quotes[index].to_json
end

