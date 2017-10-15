# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
module Persuade
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  def persuade_stage_2
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information. 2'
      persuade_stage_qr_2 = UI::QuickReplies.build(['I am ready', 'TRUST_STAGE_1'], ['Tell me more', 'PERSUADE'])
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
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST_STAGE_1'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_4
    else
      next_command :trust_stage_2
    end
  end
  def persuade_stage_4
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information.4'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST_STAGE_1'], ['Tell me more', 'PERSUADE'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_stage_5
    else
    end
  end
  def persuade_stage_5
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      say 'More information. 5 final'
      persuade_stage_qr_3 = UI::QuickReplies.build(['I am ready', 'TRUST_STAGE_1'], ['Quit', 'QUIT_SURVEY'])
      say 'Ready to browse the best?', quick_replies: persuade_stage_qr_3
      next_command :persuade_unsuccessful
    else
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
    end

  end

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
