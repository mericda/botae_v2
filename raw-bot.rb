# rubocop:disable Metrics/BlockLength
# require 'dotenv/load' # leave this line commented while working with heroku
require 'facebook/messenger'
require 'sinatra'

require_relative 'rubotnik/rubotnik'
require_relative 'helpers/helpers'
include Facebook::Messenger
include Helpers # mixing helpers into the common namespace
# so they can be used outside of Dispatches

#PERSUADE_STAGE_1_1_PHRASES = ["I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare. For now, I can only search food or coffee places.","Need something to eat 🍱 or drink ☕️? I am the one who will find the best place."]
#PERSUADE_STAGE_1_2_PHRASES = ["I try to understand the context, in this case where you are, and navigate you in the overcrowded food and coffee scene.","I use data to better understand the context,and suggest personalized places to check out."]
#PERSUADE_STAGE_2_1_PHRASES = ["Why Botae? Botae is its designer\'s early exploration of how Messenger bots can interact with users.","The idea of Botae came from its designer\'s own need of finding that best place to eat nearby."]
#PERSUADE_STAGE_2_2_PHRASES = ["Botae answers the question of \'Where should I eat now?\'","Botae is a bot, because you don\'t need another app in your phone, right?"]
#PERSUADE_STAGE_3_1_PHRASES = ["I\'m designed by Meric Dagli, who is a graduate interaction design student at Carnegie Mellon University.","I\'m designed by Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from 🇹🇷","My father is Meriç Dağlı, who is a graduate interaction design student at Carnegie Mellon University.","My father is Meric Dagli, an interaction design student from Carnegie Mellon University.","My father is Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from Turkey."]
#PERSUADE_STAGE_3_2_PHRASES = []
#PERSUADE_STAGE_4_1_PHRASES = ["In addition, I may also find places among your Facebook Friends by running a similarity-based classification algorithm.","In addition, I may also find places among your Facebook Friends by running a smart algorithm."]
#PERSUADE_STAGE_4_2_PHRASES = ["I said \'I may find it\' is because I cannot always read data of your friends, or simply there is not enough data.","I said \'I may find it\' is because I cannot always read data of your friends."]
#PERSUADE_STAGE_5_1_PHRASES = ["Want to see some suggestions before you try? Here is a screenshot of one of my earlier suggestions.","Not sure about trying me? Here is an example suggestion."]
#PERSUADE_STAGE_5_2_PHRASES = ["http://mericdagli.com/botae/p1.jpg","http://mericdagli.com/botae/p2.jpg"]


=begin
  #+++++++++++
  #FACEBOOK LIST TRIAL
  #DESIGNED FOR PERSUADE_STAGE_4
        @message.reply(
          attachment: {
            type: 'template',
            payload: {
              template_type: 'list',
              top_element_style: 'compact',
              elements: [
                {
                  title: "1. The Porch",
                  subtitle: "45 friends checked-in here.",
                  image_url: "http://www.mericdagli.com/botae/pr-1.jpg",
                  buttons: [
                    {
                      title: "Directions",
                      type: "web_url",
                      url: "https://www.google.com/search?q=The+Porch+at+Schenley",

                    }
                  ]
                },
                {
                  title: "2. Sushi Fuku",
                  subtitle: "32 friends checked-in here.",
                  image_url: "http://www.mericdagli.com/botae/pr-2.jpg",
                  default_action: {
                    type: "web_url",
                    url: "https://www.google.com/search?q=Sushi+Fuku",

                  },
                  buttons: [
                    {
                      title: "Directions",
                      type: "web_url",
                      url: "https://peterssendreceiveapp.ngrok.io/shop?item=101",

                    },
                  ]
                },
                {
                  title: "3. Pamela\'s Dinner",
                  subtitle: "29 friends checked-in here.",
                  image_url: "http://www.mericdagli.com/botae/pr-3.jpg",
                  default_action: {
                    type: "web_url",
                    url: "https://www.google.com/search?q=Pamela+Dinner",

                  },
                  buttons: [
                    {
                      title: "Directions",
                      type: "web_url",
                      url: "https://peterssendreceiveapp.ngrok.io/shop?item=101",

                    },
                  ]
                }
              ],
              buttons: [
                {
                  title: "View More Places",
                  type: "postback",
                  payload: "LEARN_MORE"
                }
              ]
            }
          }
        )

        #+++++++++++
=end


############# START UP YOUR BOT, SET UP GREETING AND MENU ###################

# NB: Subcribe your bot to your page here.
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

# Enable "Get Started" button, greeting and persistent menu for your bot
Rubotnik::BotProfile.enable
Rubotnik::PersistentMenu.enable

############################################################################

# NOTE: QuickReplies.build should be called with a splat operator
# if a set of quick replies is an array of arrays.
# e.g. UI::QuickReplies.build(*replies)
HINTS = UI::QuickReplies.build(['Where am I?', 'LOCATION'],
                               ['Take questionnaire', 'QUESTIONNAIRE'], ['Have a gif', 'HAVEAGIF'])

# Build a quick reply that prompts location from user
LOCATION_PROMPT = UI::QuickReplies.location

# Define vartiables you want to use for both messages and postbacks
# outside both Bot.on method calls.
questionnaire_replies = UI::QuickReplies.build(%w[Yes START_QUESTIONNAIRE],
                                               %w[No STOP_QUESTIONNAIRE])
questionnaire_welcome = 'Welcome to the sample questionnaire! Are you ready?'



#def firstEntity(nlp, name)
#  return nlp && nlp.entities && nlp.entities && nlp.entities[name] && nlp.entities[name][0]
#end


#greetings = firstEntity(@message.nlp, 'greetings')
#        if greetings && greetings.confidence > 0.8
#          say 'it works',
  #      end

####################### ROUTE MESSAGES HERE ################################

Bot.on :message do |message|
  # Use DSL inside the following block:
  Rubotnik::MessageDispatch.new(message).route do
    # All strings will be turned into case insensitive regular expressions.
    # If you pass a number of strings, any match will trigger a command,
    # unless 'all: true' flag is present. In that case, MessageDispatch
    # will expect all words to be present in a single message.

    # Use with 'to:' syntax to bind to a command found inside Commands
    # or its sub-modules.
    bind 'carousel', 'generic template', to: :show_carousel
    bind 'button', 'template', all: true, to: :show_button_template
    bind 'image', to: :send_image

    # bind also takes regexps directly
    bind(/my name/i, /mon nom/i) do
      user_info = get_user_info(:first_name,:last_name,:profile_pic)
      if user_info
        user_name = user_info[:first_name]
                last_name = user_info[:last_name]
                                img_url = user_info[:profile_pic]
        say "Your name is #{user_name}."
        say "Your lastname is #{last_name}."
      say "This is your profile photo."
      UI::ImageAttachment.new(img_url).send(@user)

      else
        say 'I could not get your name, sorry :('
      end
    end
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
    puts "Entity with max confidence: #{entity_max} #{confidence_max}"
    if entity_max == 'greetings' && confidence_max > 0.9
            say "Hello!"
          elsif  entity_max == 'bye' && confidence_max > 0.9
                say "bye!"

    end
end


    # Use with block if you want to provide response behaviour
    # directly without looking for an existing command inside Commands.
    bind 'knock' do
      say "Who's there?"
    end

  #  bind 'hi', 'hello', 'yo', 'hey' do
  #      say "Nice to meet you! Here's what I can do", quick_replies: HINTS
    #  end


    bind 'all', 'true', all:true do
      say "all true really"
    end



    # Use with 'to:' and 'start_thread:' to point to the first
    # command of a thread. Thread should be located in Commands
    # or a separate module mixed into Commands.
    # Include nested hash to provide a message asking user
    # for input to the next command. You can also pass an array of
    # quick replies (and process them inside the thread).
    bind 'questionnaire', to: :start_questionnaire, start_thread: {
      message: questionnaire_welcome,
      quick_replies: questionnaire_replies
    }

    bind 'where', 'am', 'I', all:true, to: :lookup_location, start_thread: {
      message: 'Let me know your location',
      quick_replies: LOCATION_PROMPT
    }

    bind "Have a gif", to: :get_cute_gif


    # Falback action if none of the commands matched the input,
    # NB: Should always come last. Takes a block.
    default do

        say 'Here are some suggestions for you:', quick_replies: HINTS


          #      greetings = firstEntity(@message.nlp, 'greetings')
          #        if greetings && greetings.confidence > 0.8
          #          say 'it works',
            #      end
    end
  end
end

######################## ROUTE POSTBACKS HERE ###############################

Bot.on :postback do |postback|
  Rubotnik::PostbackDispatch.new(postback).route do
    bind 'START' do
      say 'Hello and welcome!'
      say 'Here are some suggestions for you:', quick_replies: HINTS
    end

    bind 'CAROUSEL', to: :show_carousel
    bind 'BUTTON_TEMPLATE', to: :show_button_template
    bind 'IMAGE_ATTACHMENT', to: :send_image

    # Use block syntax when a command takes an argument rather
    # than 'message' or 'user' (which are accessible from everyhwere
    # as instance variables, no need to pass them around).
    bind 'BUTTON_TEMPLATE_ACTION' do
      say "I don't really do anything useful"
    end

    bind 'SQUARE_IMAGES' do
      show_carousel(image_ratio: :square)
    end

    # No custom parameter passed, can use simplified syntax
    bind 'HORIZONTAL_IMAGES', to: :show_carousel
    bind 'HAVEAGIF', to: :get_cute_gif
    bind 'LOCATION', to: :lookup_location, start_thread: {
      message: 'Let me know your location',
      quick_replies: LOCATION_PROMPT
    }

    bind 'QUESTIONNAIRE', to: :start_questionnaire, start_thread: {
      message: questionnaire_welcome,
      quick_replies: questionnaire_replies
    }
  end
end

##### USE STANDARD SINATRA TO IMPLEMENT WEBHOOKS FOR OTHER SERVICES #######




# Example of API integration. Use regular Sintatra syntax to define endpoints.
post '/incoming' do
  begin
    sender_id = params['id']
    user = UserStore.instance.find_or_create_user(sender_id)
    say("You got a message: #{params['message']}", user: user)
  rescue
    p 'User not recognized or not available at the time'
  end
end

get '/' do
  'Nothing to look at'
end
