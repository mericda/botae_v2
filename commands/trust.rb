require 'httparty'
require 'json'
# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
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
    LOCATION_PROMPT = UI::QuickReplies.location
    say 'Send me your location by clicking the button below and I \'ll tell you what\'s the location close to you.', quick_replies: LOCATION_PROMPT
    next_command :lookup_location
  end


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
    :show_carousel
    trust_stage_qr_3 = UI::QuickReplies.build(['Yay', 'TRUST_STABLE'], ['Quit', 'TRUST_NOT_STABLE'])
      say 'Did you like it?', quick_replies: trust_stage_qr_3
      if @message.quick_reply == 'TRUST_STABLE' || @message.text =~ /yes/i
        say 'Stable 🙌'
      else
        say 'Sorry to hear that 😭'
      end
      trust_stage_qr_3_3 = UI::QuickReplies.build(['Yes', 'TRUST_CONFIRMATION_INTENT'], ['No', 'TRUST_NOT_STABLE'])
        say 'Are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_3_3
        next_command :trust_stage_4
  end
  def trust_stage_4
      if @message.quick_reply == 'TRUST_CONFIRMATION_INTENT' || @message.text =~ /yes/i
        persuade_stage_qr_4 = UI::QuickReplies.build(['Get Authentication Pop-up', 'TRUST'], ['Tell me more', 'PERSUADE'])
        say 'Cool! In order to do that I need to get your permissions to read your friends list on Facebook. Click to button to get the Facebook authentication pop-up.', quick_replies: trust_stage_qr_4
        next_command :trust_stage_5
      else
        :persuade_stage_2
      end
      trust_stage_qr_2_2 = UI::QuickReplies.build(['Yes', 'FINAL_TRUST_CONFIRMATION'], ['No', 'TRUST_NOT_STABLE'])
        say 'Are you ready to see the most popular places among your Facebook friends?', quick_replies: trust_stage_qr_2_2
        next_command :trust_stage_4
  end

end
