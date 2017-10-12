# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
module Persuade
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  def persuade_stage_2
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'So I am a chatbot that searches for the best restaurants on Yelp, Facebook, Foursquare that is close to your location.'
      say 'I can only search food or coffee places in general. Soon I will be also able to suggest meal specific places.'
      say 'such as 🍕 Pizza or 🥗 Salad'
      persuade_stage_qr_2 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_2
      next_command :persuade_stage_3
    else
      stop_thread
      next_command :trust_stage_2
    end
  end
  def persuade_stage_3
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information. 3'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_4
    else
      stop_thread
      next_command :trust_stage_2
    end
  end
  def persuade_stage_4
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information.4'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_5
    else
      stop_thread
      next_command :trust_stage_2
    end
  end
  def persuade_stage_5
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information. 5 final'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Quit', 'QUIT_SURVEY'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_unsuccessful
    else
      stop_thread
      next_command :trust_stage_2
    end
  end
  def persuade_unsuccessful
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'QUIT_SURVEY' || @message.text =~ /yes/i
      say 'Sorry to hear that!'
      say 'Is there any question that you want to ask me?'
      persuade_stage_qr_3 = UI::QuickReplies.build(%w[I am ready TRUST], %w[No BYE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_5
    else
      stop_thread
      next_command :trust_stage_2
    end
  end


end