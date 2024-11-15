require './app'

port = ENV['PORT'] || 3000
puts "Starting server on port #{port}"

run Sinatra::Application