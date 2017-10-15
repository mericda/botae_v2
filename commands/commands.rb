require 'httparty'
require 'json'
require 'giphy'
require_relative '../ui/ui'
require_relative 'questionnaire'
require_relative 'show_ui_examples'
require_relative 'persuade'
require_relative 'trust'
# Everything in this module will become private methods for Dispatch classes
# and will exist in a shared namespace.
module Commands
  # Mix-in sub-modules for threads
  include Questionnaire
  include ShowUIExamples
  include Persuade
  include Trust

  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function


  def get_cute_gif


  get_gif_for "cute dog"

  end


  def get_gif_for query


  Giphy::Configuration.configure do |config|
    config.api_key = ENV["GIPHY_API_KEY"]
  end

  results = Giphy.search( query, {limit: 50})
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

def entity_check
  if message_contains_location?
  else
    entities = @message.nlp["entities"]
    puts "#{entities}"
    keys = entities.keys
    # store the entity with the
    # highest confidence
    entity_max = nil
    confidence_max = 0
    puts "#{keys.to_s}"
    # iterate over the keys and find
    #the one with the highest confidence
    keys.each do |key|
      confidence = entities[key].first['confidence']
      confidence = confidence.to_f
      puts "#{key} #{confidence}"
      if confidence > confidence_max
        entity_max = key
        confidence_max = confidence
      end

    
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

end
