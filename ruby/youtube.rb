require 'rubygems'
require "google/apis/youtube_v3"

require "trollop"
DEVELOPER_KEY = "AIzaSyAumOWDyFt8gBqaKztQoEPWoSQ-pMSRC5E"
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

Youtube = Google::Apis::YoutubeV3
youtube = Youtube::YouTubeService.new
videos = youtube.list_searches(:snippet, q: "cats")

videos.each do |video|
  puts video
end