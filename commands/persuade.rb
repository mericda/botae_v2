# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
module Persuade
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  def persuade_stage_2
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information about this project. 2'
      persuade_stage_qr_2 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_2
      next_command :persuade_stage_3
    else
      trust_stage_1

    end
  end
  def persuade_stage_3
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information about this project. 3'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_4
    else
      trust_stage_1
    end
  end
  def persuade_stage_4
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information about this project. 3'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_5
    else
      trust_stage_1
    end
  end
  def persuade_stage_5
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information about this project. 5 final'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST'], ['Quit', 'QUIT_SURVEY'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_unsuccessful
    else
      trust_stage_1
    end
  end
  def persuade_unsuccessful
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'QUIT_SURVEY' || @message.text =~ /yes/i
      say 'Sorry to hear that!'
      say 'Is there any question that you want to ask me?'
      stop_thread
    else
      trust_stage_1
    end
  end
end
