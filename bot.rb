# rubocop:disable Metrics/BlockLength
# require 'dotenv/load' # leave this line commented while working with heroku
require 'facebook/messenger'
require 'sinatra'

require_relative 'rubotnik/rubotnik'
require_relative 'helpers/helpers'
include Facebook::Messenger
include Helpers # mixing helpers into the common namespace
# so they can be used outside of Dispatches

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

#HINTS = UI::QuickReplies.build(['Where am I?', 'LOCATION'],
# ['Take questionnaire', 'QUESTIONNAIRE'], ['Have a gif', 'HAVEAGIF'])


GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa", "Merhaba!"]
INTROS = ["I'm Botae.", "I am Botae.", "Boate at your service.", "You are speaking with Botae."]
BYE = ["Goodbye!","Have a good one!", "Hey","Howdy", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa", "Merhaba!"]
APOLOGIES = ["I didn't catch that.", "Hmmm I don't know that word.", "I don\'t understand everything. "]
HELP = ["I can help you to find the closest best places for a coffee or food. Ready to go?", "I know the best places for coffee or food nearby. Ready to find out?", "I do one thing good: Finding the best food and coffee nearby. Are you ready?"]
NO = ["Tell me more","More information"]
YES = ["Sounds good", "I am in","Yeah","Let'\s do it","Yes","Sounds good to me","Yes, I\'m ready"]


intention_replies = UI::QuickReplies.build(['I am ready', 'TRUST_STAGE_1'], ['Tell me more', 'PERSUADE_STAGE_1'])


# Build a quick reply that prompts location from user
#LOCATION_PROMPT = UI::QuickReplies.location

questionnaire_replies = UI::QuickReplies.build(%w[Yes START_QUESTIONNAIRE],
  %w[No STOP_QUESTIONNAIRE])
  questionnaire_welcome = 'Welcome to the sample questionnaire! Are you ready?'
  # Define vartiables you want to use for both messages and postbacks
  # outside both Bot.on method calls.
  trust_stage_qr_1 = UI::QuickReplies.build(['☕️ Coffee', 'TRUST_STAGE_1_CHOICE_A'], ['🍱 Food', 'TRUST_STAGE_1_CHOICE_B'])

  persuade_stage_qr_1 = UI::QuickReplies.build([YES.sample, 'TRUST'], [NO.sample, 'PERSUADE'])

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



      # Use with block if you want to provide response behaviour
      # directly without looking for an existing command inside Commands.

      #  bind 'hi', 'hello', 'yo', 'hey' do
      #      say "Nice to meet you! Here's what I can do", quick_replies: HINTS
      #  end

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

      bind 'i', 'am', 'ready', all:true, to: :trust_stage_2, start_thread: {
        composer_input_disabled: true

        message: "Cool! What are you interested in?", quick_replies: trust_stage_qr_1
      }

      bind 'tell', 'me', 'more', all:true, to: :persuade_stage_2, start_thread: {
        composer_input_disabled: true

        message: "So I am a chatbot that searches for the best places on Yelp, Facebook, Foursquare that is close to your location.\n I can only search food or coffee places in general.", quick_replies: persuade_stage_qr_1
      }


      bind "Have a gif", to: :get_cute_gif


      # Falback action if none of the commands matched the input,
      # NB: Should always come last. Takes a block.
      default do
        if text_message?
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
          user_info = get_user_info(:first_name,:last_name,:profile_pic)
          if user_info
            user_name = user_info[:first_name]


            puts "Entity with max confidence: #{entity_max} #{confidence_max}"
            if entity_max == 'greetings' && confidence_max > 0.9
              say GREETINGS.sample + " #{user_name} 👋, " + HELP.sample
              say 'I can also find the places popular among your Facebook friends.'
              say 'Ready to browse the best?', quick_replies: intention_replies
            elsif  entity_max == 'bye' && confidence_max > 0.9
              say BYE.sample + " #{user_name} ✌️, "
            elsif  entity_max == 'help' && confidence_max > 0.9
              say "I can help you to find the closest best places for a coffee or food."
              say 'Ready to browse the best?', quick_replies: intention_replies
            else
              say   APOLOGIES.sample + " Instead, " + HELP.sample, quick_replies: intention_replies
            end
          else
            say   APOLOGIES.sample + " Instead, " + HELP.sample, quick_replies: intention_replies
            #, quick_replies: HINTS

          end
        else
        end

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

      ## START THE CONVERSATION
      bind 'START' do
        composer_input_disabled: true
        say 'Hi! 👋 I am here to find the closest best places for food and coffee to you.'
        say 'I can also find the places popular among your Facebook friends.'
        UI::ImageAttachment.new('https://media.giphy.com/media/jKaFXbKyZFja0/giphy.gif').send(@user)
        say 'Ready to browse the best?', quick_replies: intention_replies
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


      bind 'QUESTIONNAIRE', to: :start_questionnaire, start_thread: {
        message: questionnaire_welcome,
        quick_replies: questionnaire_replies
      }
      bind 'TRUST_STAGE_1', to: :trust_stage_2, start_thread: {
        composer_input_disabled: true
        message:  "Cool! What are you interested in?", quick_replies: trust_stage_qr_1
      }
      bind 'PERSUADE_STAGE_1', to: :persuade_stage_2, start_thread: {
        composer_input_disabled: true
        message: "So I am a chatbot that searches for the best restaurants on Yelp, Facebook, Foursquare that is close to your location.\n I can only search food or coffee places in general. Soon I will be also able to suggest meal specific places.\n such as 🍕 Pizza or 🥗 Salad", quick_replies: persuade_stage_qr_1
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
