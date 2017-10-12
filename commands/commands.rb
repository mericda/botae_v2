require 'httparty'
require 'json'
require 'giphy'
require_relative '../ui/ui'
require_relative 'questionnaire'
require_relative 'show_ui_examples'
# Everything in this module will become private methods for Dispatch classes
# and will exist in a shared namespace.
module Commands
  # Mix-in sub-modules for threads
  include Questionnaire
  include ShowUIExamples

  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
  REVERSE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze


  def get_gif_for(query)


  Giphy::Configuration.configure do |config|
    config.api_key = ENV["GIPHY_API_KEY"]
  end

  results = Giphy.search(query, {limit: 50})
  gif = nil

  #puts results.to_yaml
  unless results.empty?
    gif = results.sample.fixed_width_downsampled_image.url.to_s
  end

  img_url = gif
  puts "gif"
  puts "img_url"

    say("Here is a cute dog. Try again for another one.")
  UI::ImageAttachment.new(img_url).send(@user)
end


def get_trending_gif
  Giphy::Configuration.configure do |config|
    config.api_key = ENV["GIPHY_API_KEY"]
  end

  results = Giphy.trending(limit: 10)
  gif = nil

  #puts results.to_yaml
  unless results.empty?
    gif = results.sample.fixed_width_downsampled_image.url.to_s
  end

  img_url = gif
  puts "gif"
  puts "img_url"

    say("Here is your gif")
  UI::ImageAttachment.new(img_url).send(@user)

end

  # Lookup based on location data from user's device
  def lookup_location
    if message_contains_location?
      handle_user_location
    else
      say("Please try your request again and use 'Send location' button")
    end
    stop_thread
  end

  def handle_user_location
    coords = @message.attachments.first['payload']['coordinates']
    lat = coords['lat']
    long = coords['long']
    @message.typing_on
    parsed = get_parsed_response(REVERSE_API_URL, "#{lat},#{long}")
    address = extract_full_address(parsed)
    say "Looks like you're at #{address}"
    @message.typing_off
  end

  # Talk to API
  def get_parsed_response(url, query)
    response = HTTParty.get(url + query)
    parsed = JSON.parse(response.body)
    parsed['status'] != 'ZERO_RESULTS' ? parsed : nil
  end

  def extract_full_address(parsed)
    parsed['results'].first['formatted_address']
  end
end
