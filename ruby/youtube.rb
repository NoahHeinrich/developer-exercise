require 'rubygems'
require "google/apis/youtube_v3"
DEVELOPER_KEY = "AIzaSyAumOWDyFt8gBqaKztQoEPWoSQ-pMSRC5E"
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
puts "Please enter what you want to search for"
search_term = gets.chomp!
Youtube = Google::Apis::YoutubeV3
youtube = Youtube::YouTubeService.new
youtube.key = DEVELOPER_KEY
videos = youtube.list_searches(:snippet, max_results: 3, q: search_term)

videos.items.each do |video|
  p video.to_h[:snippet][:title]
end