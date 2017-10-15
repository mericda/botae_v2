# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.\

LOCATION_PROMPT = UI::QuickReplies.location
NAY_FEEDBACK = [['My location were not accurate', 'TEST_1'],['Yese', 'TEST_2'],['Yesa', 'TEST_3']]
EMAIL_TEXT = "If you have questions about this research, please contact the researcher, Meric Dagli.".freeze
EMAIL = [
  {
    type: :web_url,
    url: 'http://www.mericdagli.com',
    title: "Contact the Researcher"
  }
].freeze



COFFEE = [
  {
    title: 'Random image',
    # Horizontal image should have 1.91:1 ratio
    image_url: 'https://unsplash.it/760/400?random',
    subtitle: "That's a first card in a carousel",
    default_action: {
      type: 'web_url',
      url: 'https://unsplash.it'
    },
    buttons: [
      {
        type: :web_url,
        url: 'https://unsplash.it',
        title: 'Website'
      },
      {
        type: :postback,
        title: 'Square Images',
        payload: 'SQUARE_IMAGES'
      }
    ]
  },
  {
    title: 'Another random image',
    # Horizontal image should have 1.91:1 ratio
    image_url: 'https://unsplash.it/600/315?random',
    subtitle: "And here's a second card. You can add up to 10!",
    default_action: {
      type: 'web_url',
      url: 'https://unsplash.it'
    },
    buttons: [
      {
        type: :web_url,
        url: 'https://unsplash.it',
        title: 'Website'
      },
      {
        type: :postback,
        title: 'Unsquare Images',
        payload: 'HORIZONTAL_IMAGES'
      }
    ]
  }
].freeze


FOOD = [
  {
    title: 'Random image',
    # Horizontal image should have 1.91:1 ratio
    image_url: 'https://unsplash.it/760/400?random',
    subtitle: "That's a first card in a carousel",
    default_action: {
      type: 'web_url',
      url: 'https://unsplash.it'
    },
    buttons: [
      {
        type: :web_url,
        url: 'https://unsplash.it',
        title: 'Website'
      },
      {
        type: :postback,
        title: 'Square Images',
        payload: 'SQUARE_IMAGES'
      }
    ]
  },
  {
    title: 'Another random image',
    # Horizontal image should have 1.91:1 ratio
    image_url: 'https://unsplash.it/600/315?random',
    subtitle: "And here's a second card. You can add up to 10!",
    default_action: {
      type: 'web_url',
      url: 'https://unsplash.it'
    },
    buttons: [
      {
        type: :web_url,
        url: 'https://unsplash.it',
        title: 'Website'
      },
      {
        type: :postback,
        title: 'Unsquare Images',
        payload: 'HORIZONTAL_IMAGES'
      }
    ]
  }
].freeze

module Trust
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
  REVERSE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

  def trust_stage_2
    fall_back && return
    @@choice = nil
    if @message.quick_reply == 'TRUST_STAGE_1_CHOICE_A' || @message.text =~ /yes/i
@message.typing_on
      say 'Nice! Let me see if I can find ☕️ better than Starbucks.'


      @@choice = 'coffee'
    else
@message.typing_on
      say 'Nice! Let me see if I can find 🍽 better than Subway.'
      @@choice = 'food'
    end
    #log = @message.text
@message.typing_on
    say 'Send me your location by clicking the button below and I\'ll tell you what\'s the location close to you.', quick_replies: LOCATION_PROMPT
    next_command :lookup_location
  end


  def lookup_location
    if message_contains_location?
      handle_user_location
    else
      say "Please try your request again and use \'Send location\' button below", quick_replies: LOCATION_PROMPT
      next_command :lookup_location
    end

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
    if @@choice == 'coffee'
      UI::FBCarousel.new(COFFEE).send(@user)
    elsif @@choice == 'food'
      UI::FBCarousel.new(FOOD).send(@user)
    end
    trust_stage_qr_3_1 = UI::QuickReplies.build(['Yes', 'TRUST_STABLE'], ['No', 'TRUST_NOT_STABLE'])
    say 'Did you like it?', quick_replies: trust_stage_qr_3_1
    next_command :trust_stage_3
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


  def trust_stage_3
    fall_back && return
    entity_check
    # Fallback functionality if stop word used or user input is not text
    if @message.quick_reply == 'TRUST_STABLE' || @message.text =~ /yes/i
      #log = @message.text
      say 'Great 🙌'

    else
      #
      say 'Sorry to hear that 😭'


      trust_stage_qr_feedback= UI::QuickReplies.build(*NAY_FEEDBACK)
      say 'Let me know why you didn\'t like it. ', quick_replies: trust_stage_qr_feedback
    end
    trust_stage_qr_3_2 = UI::QuickReplies.build(['Yes', 'TRUST_CONFIRMATION_INTENT'], ['No', 'TRUST_NOT_STABLE'])
@message.typing_on
    say 'Alright, are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_3_2
    next_command :trust_stage_4
  end



  def trust_stage_4
    fall_back && return
    #log = @message.text

    if @message.quick_reply == 'TRUST_CONFIRMATION_INTENT' || @message.text =~ /yes/i
      trust_stage_qr_4 = UI::QuickReplies.build(['Authenticate', 'TRUST'])
@message.typing_on
      say 'Cool! In order to do that I need to get your permissions to read your friends list on Facebook. Click to button to get the Facebook authentication pop-up.', quick_replies: trust_stage_qr_4
      next_command :trust_stage_5
    else
      UI::ImageAttachment.new('https://media.giphy.com/media/rHUCLo2s1otC8/giphy.gif').send(@user)
@message.typing_on
      say 'Type \'friends\' to if you want to see the most popular places among your friends any time.'
      stop_thread

    end
  end


  def trust_stage_5
    fall_back && return

    if @message.quick_reply == 'TRUST' || @message.text =~ /yes/i

      trust_auth_1

    else
      trust_stage_qr_5 = UI::QuickReplies.build(['Try again', 'TRUST_CONFIRMATION_INTENT'], ['Tell me more', 'TRUST_NOT_STABLE'])
@message.typing_on
      say 'You need to click the button to give me permission to read your Facebook profile.', quick_replies: trust_stage_qr_5
      next_command :trust_stage_4

    end
  end


  def trust_auth_1
    #handle_facebook_auth
    # if FACEBOOK_AUTH == 1
    fall_back && return

    #  say 'Now, give me some time while I am looking what your friends did.'
    #  say 'I will let you know when I am ready to share the results.'
    user_info = get_user_info(:first_name)
    if user_info
      user_name = user_info[:first_name]
      say "#{user_name}, I have both good and bad news."
    else
      say "I have both good and bad news."
    end


  @message.typing_on
    say 'Bad news first.'

    trust_auth_qr_1 = UI::QuickReplies.build(['Whaat?', 'WHAT'], ['Good News?', 'GOOD_NEWS'])
@message.typing_on
sleep 3
    say 'I will be honest with you. Although you trusted me to show you popular places among your friends, I am not designed to process such information.', quick_replies: trust_auth_qr_1
    next_command :trust_auth_2

  end


  def trust_auth_2
    fall_back && return

    if @message.quick_reply == 'WHAT' || @message.text =~ /yes/i
@message.typing_on
sleep 3
      say 'I know. I am sorry if this makes you feel upset. I believe good news will make you feel good.'

    end
    @message.typing_on
sleep 3
    trust_auth_qr_2  = UI::QuickReplies.build(['Got it', 'SKIP'], ['Why?', 'CONTINUE'])
    say 'Your data is safe, and I\'m designed to show how easy it is to trust a program like myself to give access for personal data.', quick_replies: trust_auth_qr_2
    next_command :trust_auth_3

  end

  def trust_auth_3
    fall_back && return
    if @message.quick_reply == 'CONTINUE' || @message.text =~ /yes/i
@message.typing_on
sleep 3
      say 'There are many malicious bots that have bad intention. They can steal your personal information such as your account or location.'
@message.typing_on
sleep 3
      say 'I want to warn you one more time to think twice when you are providing access or directly giving your personal information to a computer program.'
    end

  @message.typing_on
  sleep 3
    say 'I am part of a research project at Carnegie Mellon University that investigates the trust between users and computer programs.'
@message.typing_on
sleep 3
    say 'I hope you understand my good intentions. '
    UI::FBButtonTemplate.new(EMAIL_TEXT,EMAIL).send(@user)
@message.typing_on
sleep 1
    say 'Thank you! '
    UI::ImageAttachment.new('https://media.giphy.com/media/3orieR0VunUxJKfwHe/giphy.gif').send(@user)
stop_thread

  end
  #else #IF_FACEBOOK_AUTH == 0
  #trust_stage_qr_final_redirect= UI::QuickReplies.build(['Try again to authenticate', 'TRUST'], ['Tell me more', 'TRUST_NOT_STABLE'])
  #say 'Something is wrong, I could not get confirmation from Facebook.', quick_replies: trust_stage_qr_final_redirect
  #next_command :trust_stage_5
  #stop_thread #INTERIM
  #end
  #GET CONFIRMATION OF USERS

  # NOTE: A way to enforce sanity checks (repeat for each sequential command)
  def fall_back
    say 'You tried to fool me, human! Start over!' unless text_message?
    return false unless !text_message? || stop_word_used?('Stop')
    stop_questionnaire
    puts 'Fallback triggered!'
    true # to trigger return from the caller on 'and return'
  end

  # specify stop word
  def stop_word_used?(word)
    !(@message.text =~ /#{word.downcase}/i).nil?
  end


end
