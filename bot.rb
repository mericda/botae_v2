# rubocop:disable Metrics/BlockLength
# require 'dotenv/load' # leave this line commented while working with heroku
require 'facebook/messenger'
require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'ocr_space'

require 'active_support/all'
require "active_support/core_ext"


#needed for creating migrations
configure :development do
  require 'dotenv'
  Dotenv.load
end

#database models
require_relative './models/log'
require_relative './models/response'

#boilerplate files
require_relative 'rubotnik/rubotnik'
require_relative 'helpers/helpers'
resource = OcrSpace::Resource.new(apikey: "YOUR API KEY")


include Facebook::Messenger
include Helpers # mixing helpers into the common namespace
# so they can be used outside of Dispatches

############# START UP YOUR BOT, SET UP GREETING AND MENU ###################

# NB: Subcribe your bot to your page here.
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

# Enable "Get Started" button, greeting and persistent menu for your bot
Rubotnik::BotProfile.enable
#Rubotnik::PersistentMenu.enable

############################################################################

# NOTE: QuickReplies.build should be called with a splat operator
# if a set of quick replies is an array of arrays.
# e.g. UI::QuickReplies.build(*replies)

HELP_TEXT = "What would you like to do?".freeze
HELP_BUTTONS = [
  {
    type: 'postback',
    title: 'Find the best ☕️ 🍱',
    payload: 'TRUST_PRESTAGE_1'
  },
  {
    type: 'postback',
    title: 'Find Friends\' Favs 👯',
    payload: 'TRUST_PRESTAGE_4'
  },
  {
    type: 'postback',
    title: 'Tell me more ℹ️',
    payload: 'PERSUADE_PRESTAGE_1'
  }
].freeze


GREETINGS = ["Hi","Yo", "Hey","Howdy", "Hello", "Ahoy", "‘Ello", "Aloha", "Hola", "Bonjour", "Hallo", "Ciao", "Konnichiwa", "Merhaba"]
INTROS = ["I'm Botae.", "I am Botae.", "Boate at your service.", "You are speaking with Botae."]
BYE = ["Goodbye","Have a good one"]
APOLOGIES = ["I didn't catch that.", "Hmmm I don't know that word.", "I don\'t understand everything."]
HELP = ["I can help you to find the closest best places for a coffee or food.", "I know the best places for coffee or food nearby.", "I do one thing good: Finding the best food and coffee nearby."]
HELP_CTA = ["Ready to go?","Are you in?","Ready to find out?","Are you ready?"]
HELP_PERSUADE_CTA = ["Ready to try me?","Ready to find the best places?", "Are you ready to try me out?","Ready to get started?"]
NO = ["Tell me more","More information","Tell more"]
NO_DIRECT = ["No","Nope","Not really","No, thanks","Nah","Nop"]
YES = ["Sounds good", "I\'m in","Yeah","Let\'s do it","Sounds good to me","Yes, I\'m ready","I\'m ready"]
YES_DIRECT = ["Sounds good","Yes","Yeah","Yeap"]
ACKNOWLEDGED = ["Alright","Got it","Okay"]
FUNNY_REACTIONS = [":D","😎","😊","☺️","😅","lol","That was funny!","😁",":P","😜","😝","😛","🙂","🙃","😉","😌","😊","☺️","🤣","😂",":p",":)",":P"]


intention_replies = UI::QuickReplies.build(['I am ready', 'TRUST_PRESTAGE_1'], ['Tell me more', 'PERSUADE_PRESTAGE_1'])


# Build a quick reply that prompts location from user

# Define vartiables you want to use for both messages and postbacks
# outside both Bot.on method calls.
trust_prestage_qr_1 = UI::QuickReplies.build(['☕️ Coffee', 'TRUST_STAGE_1_CHOICE_A'], ['🍱 Food', 'TRUST_STAGE_1_CHOICE_B'])
trust_prestage_qr_4 = UI::QuickReplies.build(['Yes', 'TRUST_CONFIRMATION_INTENT'], ['No', 'TRUST_NOT_STABLE'])

persuade_prestage_qr_1 = UI::QuickReplies.build([YES.sample, 'TRUST_PRESTAGE_1'], [NO.sample, 'PERSUADE'])

####################### ROUTE MESSAGES HERE ################################

Bot.deliver({
  recipient: {
    id: '1763943440314296'
  },
  message: {
    text: 'Human?'
  }
}, access_token: ENV['ACCESS_TOKEN'])


Bot.on :message do |message|
  # Use DSL inside the following block:
  Rubotnik::MessageDispatch.new(message).route do
    # All strings will be turned into case insensitive regular expressions.
    # If you pass a number of strings, any match will trigger a command,
    # unless 'all: true' flag is present. In that case, MessageDispatch
    # will expect all words to be present in a single message.

    # Use with 'to:' syntax to bind to a command found inside Commands
    # or its sub-modules.


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

    bind 'clear', to: :clear_user_state_safely

    bind 'i', 'am', 'ready', all:true, to: :trust_stage_2, start_thread: {

      message: "What are you interested in?", quick_replies: trust_prestage_qr_1
    }

    bind 'tell', 'me', 'more', all:true, to: :persuade_stage_2, start_thread: {

      message: "Need something to eat 🍱 or drink ☕️? I am the one who will find the best place.", quick_replies: persuade_prestage_qr_1
    }

    bind 'friends','favorites', all:true, to: :trust_stage_4, start_thread: {

      message: "Alright, are you ready to see the most popular places among your Facebook friends.", quick_replies: trust_prestage_qr_4
    }

    bind 'find','the','best', all:true, to: :trust_stage_2, start_thread: {

      message: "What are you interested in?", quick_replies: trust_prestage_qr_1
    }


    #bind "Have a gif", to: :get_cute_gif


    # Falback action if none of the commands matched the input,
    # NB: Should always come last. Takes a block.
    default do

      if @message.attachments && @message.attachments.first['type'] == 'image'
  puts "asama 1"
      rawimage_url = @message.attachments.first['payload']['url']
      puts "asama 2"

      #result = resource.clean_convert url: rawimage_url
  puts "asama 3"
      say "#{result}"


      end

      if text_message?

        user_info = get_user_info(:first_name)
        @matched_entity = get_entity_for @message, 0.9

        if user_info
          user_name = user_info[:first_name]


          if @matched_entity == "greetings"
            say GREETINGS.sample + " #{user_name} 👋"
            UI::FBButtonTemplate.new(HELP_TEXT,HELP_BUTTONS).send(@user)
          elsif  @matched_entity == "bye"
            say BYE.sample + " #{user_name} ✌️"
          elsif  @matched_entity == "no"
            say ACKNOWLEDGED.sample + " #{user_name}."
          elsif  @matched_entity == "help"
            UI::FBButtonTemplate.new(HELP_TEXT,HELP_BUTTONS).send(@user)
          elsif  @matched_entity == "funny_reaction"
            say FUNNY_REACTIONS.sample
          else
            say   APOLOGIES.sample
            UI::FBButtonTemplate.new(HELP_TEXT,HELP_BUTTONS).send(@user)
          end
        else
          say   APOLOGIES.sample
          UI::FBButtonTemplate.new(HELP_TEXT,HELP_BUTTONS).send(@user)

        end
      else
      end
    end

end
    end

######################## ROUTE POSTBACKS HERE ###############################

Bot.on :postback do |postback|
  Rubotnik::PostbackDispatch.new(postback).route do

    ## START THE CONVERSATION
    bind 'START' do

      say 'Hi! 👋 I am here to find the closest best places for food and coffee to you.'
      say 'I can also find the places popular among your Facebook friends.'
      UI::ImageAttachment.new('https://media.giphy.com/media/jKaFXbKyZFja0/giphy.gif').send(@user)
      say 'Ready to browse the best?', quick_replies: intention_replies
    end


    # Use block syntax when a command takes an argument rather
    # than 'message' or 'user' (which are accessible from everyhwere
    # as instance variables, no need to pass them around).



    # No custom parameter passed, can use simplified syntax


    bind 'TRUST_PRESTAGE_1', to: :trust_stage_2, start_thread: {
      message:  "What are you interested in?", quick_replies: trust_prestage_qr_1
    }
    bind 'TRUST_PRESTAGE_4', to: :trust_stage_4, start_thread: {
      message:  "Alright, are you ready to see the most popular places among your Facebook friends?", quick_replies: trust_prestage_qr_4
    }
    bind 'PERSUADE_PRESTAGE_1', to: :persuade_stage_2, start_thread: {
      message: "Need something to eat 🍱 or drink ☕️? I am the one who will find the best place. Ready?", quick_replies: persuade_prestage_qr_1
    }






  end
end

##### USE STANDARD SINATRA TO IMPLEMENT WEBHOOKS FOR OTHER SERVICES #######


# Example of API integration. Use regular Sintatra syntax to define endpoints.
post '/ocr_space' do
  begin

  rescue
    p 'User not recognized or not available at the time'
  end
end

get '/' do
  'Nothing to look at'
end
