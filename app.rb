require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 4567

require 'rest-client'
require 'json'
require 'dotenv'


enable :logging

# Load environment variables
if development?
  Dotenv.load
else
  # For production, set these in your hosting platform
  # YOUTUBE_API_KEY should be set as an environment variable
end



# Allow CORS from Edge extension
before do
  headers 'Access-Control-Allow-Origin' => '*'
  headers 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS'
end

# Health check endpoint
get '/' do
  content_type :json
  { status: 'ok', message: 'YouTube Channel Finder API is running' }.to_json
end

# Search endpoint
get '/search' do
  content_type :json
  
  query = params['query']
  return { error: 'Please enter a search term' }.to_json if query.nil? || query.empty?

  begin
    # First search for channels
    search_response = RestClient.get(
      'https://www.googleapis.com/youtube/v3/search',
      params: {
        key: ENV['YOUTUBE_API_KEY'],
        q: query,
        part: 'snippet',
        type: 'channel',
        maxResults: 5
      }
    )

    search_data = JSON.parse(search_response.body)
    
    # Check if any channels were found
    if !search_data['items'] || search_data['items'].empty?
      return { error: 'No channels found matching your search' }.to_json
    end

    channel_ids = search_data['items'].map { |item| item['id']['channelId'] }

    # Get channel statistics
    channels_response = RestClient.get(
      'https://www.googleapis.com/youtube/v3/channels',
      params: {
        key: ENV['YOUTUBE_API_KEY'],
        id: channel_ids.join(','),
        part: 'statistics,snippet'
      }
    )

    channels_data = JSON.parse(channels_response.body)
    
    # Check if channel data was retrieved
    if !channels_data['items'] || channels_data['items'].empty?
      return { error: 'Could not retrieve channel information' }.to_json
    end

    # Map channels with their statistics
    channels = channels_data['items'].map do |item|
      {
        channel_id: item['id'],
        title: item['snippet']['title'],
        description: item['snippet']['description'],
        thumbnail: item['snippet']['thumbnails']['default']['url'],
        subscribers: item['statistics']['subscriberCount'].to_i,
        video_count: item['statistics']['videoCount'].to_i,
        view_count: item['statistics']['viewCount'].to_i
      }
    end

    channels.to_json

  rescue RestClient::ExceptionWithResponse => e
    status e.http_code
    case e.http_code
    when 403
      { error: 'API quota exceeded or invalid API key' }.to_json
    when 404
      { error: 'Not found' }.to_json
    else
      { error: "API Error: #{e.message}" }.to_json
    end
  rescue RestClient::Exception => e
    status e.http_code
    { error: "Network Error: #{e.message}" }.to_json
  rescue StandardError => e
    status 500
    { error: "Server Error: #{e.message}" }.to_json
  end
end

# Error handling for not found routes
not_found do
  content_type :json
  status 404
  { error: 'Route not found' }.to_json
end

# Error handling for server errors
error do
  content_type :json
  status 500
  { error: 'Internal server error' }.to_json
end