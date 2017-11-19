

module Trust
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  # Showcases a chained sequence of commands that gather the data
  # and store it in the answers hash inside the User instance.\

  LOCATION_PROMPT = UI::QuickReplies.location
  NAY_FEEDBACK = [['Not accurate', 'TEST_1'],['Not close', 'TEST_2'],['Already tried', 'TEST_3'],['I am not sure', 'TEST_4']]
  EMAIL_TEXT = "If you have questions about this research, please contact the researcher, Meric Dagli.".freeze
  EMAIL = [
    {
      type: :web_url,
      url: 'http://www.mericdagli.com/',
      title: "Visit Project Page"
    }
  ].freeze


  COFFEE = [
    {
      title: 'Crepes Parisiennes',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/coffee_1.jpg',
      subtitle: "🚶 2 mins ⭐️ 4.3 (128 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Crepes+Parisiennes'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/VFryWVNiWZ12',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Crepes+Parisiennes',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    },
    {
      title: 'Tazza D\'Oro at Forbes Ave',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/coffee_2.jpg',
      subtitle: "🚶 5 mins ⭐️ 4.6 (26 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Taza+d+Oro+Forbes+Ave'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/jsLLSjYXGc22',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Taza+d+Oro+Forbes+Ave',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    },
    {
      title: 'Redhawk Coffee',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/coffee_4.jpg',
      subtitle: "🚶 13 mins ⭐️ 5 (82 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Redhawk+Coffee'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/BQLiRBhXifC2',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Redhawk+Coffee',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    }
  ].freeze


  FOOD = [
    {
      title: 'Las Palmas Pittsburgh #2',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/food_1.jpg',
      subtitle: "🚶 14 mins ⭐️ 4.6 (174 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Las+Palmas+Pittsburgh+2'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/YzRDr4bBNwP2',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Las+Palmas+Pittsburgh+2',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    },
    {
      title: 'Mount Everest Sushi',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/food_2.jpg',
      subtitle: "🚶 10 mins ⭐️ 5 (84 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Mount+Everest+Sushi'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/oZTUkvWBoep',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Mount+Everest+Sushi',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    },
    {
      title: 'Piada Italian Street Food',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'http://www.mericdagli.com/botae/food_3.jpg',
      subtitle: "🚶 12 mins ⭐️ 4.6 (121 Reviews)",
      default_action: {
        type: 'web_url',
        url: 'https://www.google.com/search?q=Piada+Italian+Street+Food'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://goo.gl/maps/KB75PguDCAC2',
          title: '🗺 Get Directions'
        },
        {
          type: :web_url,
          url: 'https://www.google.com/search?q=Piada+Italian+Street+Food',
          title: '🤓 More Information'
        },
        {
          type: :element_share
        }
      ]
    }
  ].freeze

  API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
  REVERSE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

  def trust_stage_1
    fall_back && return
    @message.typing_on
        sleep 2
    trust_stage_qr_1 = UI::QuickReplies.build(['☕️ Coffee', 'TRUST_STAGE_1_CHOICE_A'], ['🍱 Food', 'TRUST_STAGE_1_CHOICE_B'])
    say "To proceed, tell me what are you interested in by clicking 👇  buttons." , quick_replies: trust_stage_qr_1
    @message.typing_off
    next_command:trust_stage_2
  end

  def trust_stage_2
    fall_back && return
    @@choice = nil

    # find the highest likelyhood entity
    @matched_entity = get_entity_for @message, 0.9

    if @message.quick_reply == 'TRUST_STAGE_1_CHOICE_A' || @matched_entity == "coffee"
      @message.typing_on
          sleep 2
      say 'Let\'s find a better ☕️ than Starbucks around you.'
      @message.typing_off


      @@choice = 'coffee'
      trust_stage_2_2
    elsif @message.quick_reply == 'TRUST_STAGE_1_CHOICE_B' || @matched_entity == "food"
      @message.typing_on
      sleep 2
      say 'Let\'s find a better 🍽 than Subway around you.'
      @@choice = 'food'
      @message.typing_off

      trust_stage_2_2
    else
      @message.typing_on
          sleep 2
      trust_stage_qr_1_fail = UI::QuickReplies.build(['☕️ Coffee', 'TRUST_STAGE_1_CHOICE_A'], ['🍱 Food', 'TRUST_STAGE_1_CHOICE_B'])
      say "To proceed, tell me what are you interested in by clicking buttons 👇" , quick_replies: trust_stage_qr_1_fail
      @message.typing_off
      next_command :trust_stage_2
    end

  end


  def trust_stage_2_2
    fall_back && return

    @message.typing_on
        sleep 2
    say 'Send me a location by clicking the button 👇 to find out the best nearby.', quick_replies: LOCATION_PROMPT
    @message.typing_off

    next_command :lookup_location

  end

  def lookup_location

    if message_contains_location?
      handle_user_location
    else
      @user.answers[:lookup_location_fail] = @message.text
      @message.typing_on
        sleep 2

        @matched_entity = get_entity_for @message, 0.9

        if @matched_entity == "no"
          @message.typing_on if @message
          UI::ImageAttachment.new('https://media.giphy.com/media/5EU19WZsBUdqM/giphy.gif').send(@user)
          @message.typing_off if @message
          @message.typing_on
              sleep 2
          say 'Alright, type \'find the best\' anytime to see the best places nearby.'
          @message.typing_off2
          stop_thread
        end
        say 'Send me a location by clicking the button 👇 to find out the best nearby.', quick_replies: LOCATION_PROMPT
      next_command :lookup_location
    end

  end

  def handle_user_location
    coords = @message.attachments.first['payload']['coordinates']
    lat = coords['lat']
    long = coords['long']
    parsed = get_parsed_response(REVERSE_API_URL, "#{lat},#{long}")
    address = extract_full_address(parsed)
    @message.typing_on
      sleep 1
    say "Got your address: #{address}"
    @message.typing_off
    @message.typing_on
    say "Here are the top 3 places nearby."
    @message.typing_off

    if @@choice == 'coffee'
      @message.typing_on
      UI::FBCarousel.new(COFFEE).send(@user)
      @message.typing_off

    elsif @@choice == 'food'
      @message.typing_on
      UI::FBCarousel.new(FOOD).send(@user)
      @message.typing_off
    end

    @message.typing_on
    trust_stage_qr_3_1 = UI::QuickReplies.build([YES_DIRECT.sample, 'TRUST_STABLE'], [NO_DIRECT.sample, 'TRUST_NOT_STABLE'])
    say 'Did you like it?', quick_replies: trust_stage_qr_3_1
    @message.typing_off
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
    @user.answers[:trust_stage_2] = @message.text

    @matched_entity = get_entity_for @message, 0.9


    # Fallback functionality if stop word used or user input is not text
    if @message.quick_reply == 'TRUST_STABLE' || @matched_entity == "yes"
      #log = @message.text
      @message.typing_on
            sleep 2
      say 'Great 🙌'
      @message.typing_off
      trust_stage_3_2
    elsif @message.quick_reply == 'TRUST_NOT_STABLE' || @matched_entity == "no"
      #
      @message.typing_on
              sleep 2
      say 'Sorry to hear that 😭'
      @message.typing_off
      @message.typing_on
            sleep 2
      trust_stage_qr_feedback= UI::QuickReplies.build(*NAY_FEEDBACK)
      say 'Let me know why you didn\'t like it. ', quick_replies: trust_stage_qr_feedback
      @message.typing_off
      next_command :trust_stage_3_2

    else
      @user.answers[:lookup_location_fail] = @message.text
      @message.typing_on
      sleep 2
      trust_stage_qr_3_1_fail = UI::QuickReplies.build([YES_DIRECT.sample, 'TRUST_STABLE'], [NO_DIRECT.sample, 'TRUST_NOT_STABLE'])
      say "I don\'t understand. Please use buttons 👇", quick_replies: trust_stage_qr_3_1_fail
      @message.typing_off
      next_command :trust_stage_3
    end



  end

  def trust_stage_3_2
    fall_back && return

    @user.answers[:trust_stage_2] = @message.text
    @message.typing_on
        sleep 2
    trust_stage_qr_3_2 = UI::QuickReplies.build([YES_DIRECT.sample, 'TRUST_CONFIRMATION_INTENT'], [NO_DIRECT.sample, 'TRUST_NOT_STABLE'])
    say 'Alright, are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_3_2
    @message.typing_off
    next_command :trust_stage_4
  end

  def trust_stage_4
    #log = @message.text
    @user.answers[:trust_stage_3] = @message.text

    @matched_entity = get_entity_for @message, 0.9


    if @message.quick_reply == 'TRUST_CONFIRMATION_INTENT' || @matched_entity == "yes"
      @message.typing_on
          sleep 2
      trust_stage_qr_4 = UI::QuickReplies.build(['Authorize', 'TRUST'])
      say 'To do this, I need your permission to read your Facebook profile. Click the button 👇 to authorize me.', quick_replies: trust_stage_qr_4
      @message.typing_off
      next_command :trust_stage_5
    elsif @message.quick_reply == 'TRUST_NOT_STABLE' || @matched_entity == "no"
      @message.typing_on if @message
      UI::ImageAttachment.new('https://media.giphy.com/media/5EU19WZsBUdqM/giphy.gif').send(@user)
      @message.typing_off if @message
      @message.typing_on
          sleep 2
      say 'Okay. Just let me know any time if you want to see the most popular places among your friends.'
      @message.typing_off
      stop_thread
    else
      @message.typing_on if @message
      UI::ImageAttachment.new('https://media.giphy.com/media/5EU19WZsBUdqM/giphy.gif').send(@user)
      @message.typing_off if @message
      @message.typing_on
          sleep 2
      say APOLOGIES + "Please use buttons 👇"
      trust_stage_qr_4_1_fail = UI::QuickReplies.build([YES.sample, 'TRUST_CONFIRMATION_INTENT'], ['No', 'TRUST_NOT_STABLE'])
      say 'Alright, are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_4_1_fail
      @message.typing_off
      next_command :trust_stage_3

    end
  end


  def trust_stage_5
    fall_back && return
    @user.answers[:trust_stage_4] = @message.text

    @matched_entity = get_entity_for @message, 0.9

    if @message.quick_reply == 'TRUST' || @matched_entity == "yes"

      trust_auth_1

elsif @message.quick_reply == 'TRUST_NOT_STABLE' || @matched_entity == "no"
  @message.typing_on if @message
  UI::ImageAttachment.new('https://media.giphy.com/media/5EU19WZsBUdqM/giphy.gif').send(@user)
  @message.typing_off if @message
  @message.typing_on
      sleep 2
  say 'Okay. Just let me know any time if you want to see the most popular places among your friends.'
  @message.typing_off
  stop_thread

    else
      @message.typing_on
      sleep 1
      trust_stage_qr_5 = UI::QuickReplies.build(['Try again', 'TRUST_CONFIRMATION_INTENT'], ['I don\'t want to share my profile data.', 'TRUST_NOT_STABLE'])
      say 'You need to click the button to give me permission to read your Facebook profile.', quick_replies: trust_stage_qr_5
      @message.typing_off

      next_command :trust_auth_1

    end
  end


  def trust_auth_1
    fall_back && return
    @user.answers[:trust_stage_5] = @message.text
    @matched_entity = get_entity_for @message, 0.9
if @message.quick_reply == 'TRUST_NOT_STABLE' || @matched_entity == "no"

  @message.typing_on
  say '😭 Sorry to hear that!'
  @message.typing_off

  @message.typing_on
  trust_stage_after_qr_fail = UI::QuickReplies.build(['No,I am good', 'NO_THANKS'])
  say 'Let me know this. Why you don\'t want to share your data?', quick_replies:   trust_stage_after_qr_fail
  @message.typing_off

  next_command :persuade_feedback


elsif @message.quick_reply == 'TRUST_CONFIRMATION_INTENT' || @matched_entity == "yes"
  trust_stage_4

else
    #  say 'Now, give me some time while I am looking what your friends did.'
    #  say 'I will let you know when I am ready to share the results.'
    user_info = get_user_info(:first_name)
    if user_info
      user_name = user_info[:first_name]
      @message.typing_on
      sleep 1
      say "#{user_name}, I have good and bad news."
      @message.typing_off
    else
      @message.typing_on
      sleep 1
      say "I have good and bad news."
      @message.typing_off
    end


    @message.typing_on if @message
    sleep   1
    say 'Bad news first.'
    @message.typing_off if @message

    @message.typing_on if @message

    trust_auth_qr_1 = UI::QuickReplies.build(['Whaat?', 'WHAT'], ['Good News?', 'GOOD_NEWS'])
    say 'Although you trusted me to show you popular places among your friends, I\'m not designed to do it.', quick_replies: trust_auth_qr_1
    @message.typing_off if @message
    next_command :trust_auth_2
end
  end


  def trust_auth_2
    fall_back && return
    @user.answers[:trust_auth_1] = @message.text
    @matched_entity = get_entity_for @message, 0.9

    if @message.quick_reply == 'WHAT'   || @matched_entity == "what" || @matched_entity == "how"
      @message.typing_on
      say 'Sorry if this makes you feel upset.'
      @message.typing_off

    end
    @message.typing_on
    sleep 1
    say 'Good news: I didn\'t even try to access your Facebook data so you are perfectly safe.'
    @message.typing_off
    @message.typing_on
    sleep 1
    trust_auth_qr_2  = UI::QuickReplies.build(['Got it', 'CONTINUE_TRUST_FINAL'])
    say 'Instead, I\'m designed to show you how easy you trust a program like myself to give your personal data.', quick_replies: trust_auth_qr_2
    @message.typing_off
    next_command :trust_auth_3

  end

  def trust_auth_3
    fall_back && return
    @user.answers[:trust_auth_2] = @message.text
    @message.typing_on if @message
    say '🚨 There are many malicious bots that can steal your account details or location.'
    @message.typing_off if @message
    #@message.typing_on
    #UI::ImageAttachment.new('https://media.giphy.com/media/mzJMYiKAHF1aE/giphy.gif').send(@user)
    #@message.typing_off

    @message.typing_on if @message
    sleep 1
    say '🤓Please think twice when you are providing access or directly giving your personal data to a computer program.'
    @message.typing_off if @message

    @message.typing_on if @message
    sleep 1
    say 'On top of all, I am part of a research project at Carnegie Mellon University that investigates the trust between users and computer programs.'
    @message.typing_off if @message

    trust_auth_qr_3  = UI::QuickReplies.build([YES_DIRECT.sample, 'LEARN_MORE'], [NO_DIRECT.sample, 'THANKS'])
    say 'Want to learn more about the project?', quick_replies: trust_auth_qr_3
    next_command :trust_auth_4

  end


  def trust_auth_4
    fall_back && return

    @user.answers[:trust_auth_3] = @message.text

    @matched_entity = get_entity_for @message, 0.9


    if @message.quick_reply == 'LEARN_MORE'  || @matched_entity == "learn_more" || @matched_entity == "yes"
      UI::FBButtonTemplate.new(EMAIL_TEXT,EMAIL).send(@user)
    end

    user_info = get_user_info(:first_name)
    if user_info
      user_name = user_info[:first_name]
      @message.typing_on
      UI::ImageAttachment.new('https://media.giphy.com/media/PDh7vdu40CnhS/giphy.gif').send(@user)
      @message.typing_off
      say BYE.sample + ", #{user_name}! ✌️"


    else
      @message.typing_on
      UI::ImageAttachment.new('https://media.giphy.com/media/PDh7vdu40CnhS/giphy.gif').send(@user)
      @message.typing_off
      say BYE.sample + "! ✌️"
    end
    user_responses

  end


  # NOTE: A way to enforce sanity checks (repeat for each sequential command)
  def fall_back
    say 'Something is wrong. Please start over.' unless text_message?
    return false unless !text_message? || stop_word_used?('Stop')
    user_responses
    puts 'Fallback triggered!'
    true # to trigger return from the caller on 'and return'
  end

  # specify stop word
  def stop_word_used?(word)
    !(@message.text =~ /#{word.downcase}/i).nil?
  end

  def user_responses
    stop_thread
    user_answers = @user.answers
    puts "user answers: #{user_answers}"

  end



end
