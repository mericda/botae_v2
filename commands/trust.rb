# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.\

LOCATION_PROMPT = UI::QuickReplies.location
#NAY_FEEDBACK = [{['The results were not accurate']}, {['I know those places, and they are not good']}, {['Option 3']}, {['Option 4']}, {['Option 5']}, {['Option 6']}, {['Option 7']}]
EMAIL_TEXT = "Send an email to mericda@cmu.edu ".freeze
EMAIL = [
  {
    type: :web_url,
    url: 'http://www.mericdagli.com',
    title: "Send an email to mericda@cmu.edu"
  }
].freeze
module Trust
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
  REVERSE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

  def trust_stage_2
    if @message.quick_reply == 'TRUST_STAGE_1_CHOICE_A' || @message.text =~ /yes/i
      say 'Nice! Let me see if I can find something better than Starbucks.'
    else
      say 'Nice! Let me see if I can find something better than Subway.'
    end
    #log = @message.text
    say 'Send me your location by clicking the button below and I \'ll tell you what\'s the location close to you.', quick_replies: LOCATION_PROMPT
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

    show_carousel(image_ratio: :square)
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
    # Fallback functionality if stop word used or user input is not text
    if @message.quick_reply == 'TRUST_STABLE' || @message.text =~ /yes/i
      #log = @message.text
      say 'Great 🙌'

    else
      #
      say 'Sorry to hear that 😭'
      stop_thread

      #trust_stage_qr_feedback= UI::QuickReplies.build(*NAY_FEEDBACK)
      #say 'Let me know why you didn\'t like it. ', quick_replies: trust_stage_qr_feedback
      #stop_thread
    end
    trust_stage_qr_3_2 = UI::QuickReplies.build(['Yes', 'TRUST_CONFIRMATION_INTENT'], ['No', 'TRUST_NOT_STABLE'])
    say 'Anyway, Are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_3_2
    next_command :trust_stage_4
  end


  def trust_stage_4
    if @message.quick_reply == 'TRUST_CONFIRMATION_INTENT' || @message.text =~ /yes/i
      #log = @message.text
      trust_stage_qr_4 = UI::QuickReplies.build(['Authenticate', 'TRUST'])
      say 'Cool! In order to do that I need to get your permissions to read your friends list on Facebook. Click to button to get the Facebook authentication pop-up.', quick_replies: trust_stage_qr_4
      next_command :trust_stage_5
    else
      UI::ImageAttachment.new('https://media.giphy.com/media/rHUCLo2s1otC8/giphy.gif').send(@user)
      say 'Got it!'
      say 'Type \'friends\' to if you want to see the most popular places among your friends any time.'
    end
  end


  def trust_stage_5
    if @message.quick_reply == 'TRUST' || @message.text =~ /yes/i
      say 'Lets do this'
      trust_auth

    else
      trust_stage_qr_5 = UI::QuickReplies.build(['Try again', 'TRUST_CONFIRMATION_INTENT'], ['Tell me more', 'TRUST_NOT_STABLE'])
      say 'You need to click the button to give me permission to read your Facebook profile.', quick_replies: trust_stage_qr_5
      next_command :trust_stage_4

    end
  end


  def trust_auth
    #handle_facebook_auth
    # if FACEBOOK_AUTH == 1
    say 'Now, give me some time while I am looking what your friends did.'
    say 'I will let you know when I am ready to share the results.'
    #sleep 120
    say 'user_name, I have both good and bad news.'


    say 'Bad news first: I will be honest with you. Although you trusted me to show you popular places among your friends,'
    say 'I am not designed to process such informationi at first hand.'

    say 'Now, some good news. Your data is safe, and my real aim as a bot was to show how easy it is to trust a program like myself to give access for personal data. '
    say 'I am part of a research project at Carnegie Mellon University School of Design that investigates the trust between users and computer programs,'
    say 'I want to warn you one more time to think twice when you are providing access or directly giving your personal information to a computer program.'
    say 'There are many malicious bots that have bad intentions such as stealing personal information such as your accounnt or location information.'
    UI::ImageAttachment.new('https://media.giphy.com/media/3orieR0VunUxJKfwHe/giphy.gif').send(@user)
    say 'I hope you understand my good intentions. '
    say 'If you have questions or comments about this research, please e-mail the researcher, Meric Dagli from mericda@cmu.edu or visit the project page below.'
    UI::FBButtonTemplate.new(EMAIL_TEXT,EMAIL).send(@user)
    say 'Thank you! '
    stop_thread
    #else #IF_FACEBOOK_AUTH == 0
    #trust_stage_qr_final_redirect= UI::QuickReplies.build(['Try again to authenticate', 'TRUST'], ['Tell me more', 'TRUST_NOT_STABLE'])
    #say 'Something is wrong, I could not get confirmation from Facebook.', quick_replies: trust_stage_qr_final_redirect
    #next_command :trust_stage_5
    #stop_thread #INTERIM
    #end
    #GET CONFIRMATION OF USERS

  end



end
