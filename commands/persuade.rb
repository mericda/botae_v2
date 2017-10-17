# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
module Persuade
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

    FLOWS = [1,2]


  def persuade_stage_1

    puts "Return: #{PERSUADE_STAGE_2_1_PHRASES}"
    @@current_flow = FLOWS.sample.freeze
    puts "#{@@current_flow}"

    @user.answers[:persuade_stage_1] = @message.text

    if @message.quick_reply == 'TRUST_NOT_STABLE' || @message.text =~ /yes/i
      @message.typing_on
      reply_back = Response.find_by(stage_id: 1, step_id: 1, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      reply_back = Response.find_by(stage_id: 1, step_id: 2, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      persuade_stage_qr_1 = UI::QuickReplies.build([YES.sample, 'TRUST'], [NO.sample, 'PERSUADE'])
      say HELP_PERSUADE_CTA.sample, quick_replies: persuade_stage_qr_1
      @message.typing_off

      next_command :persuade_stage_2

    else
      trust_stage_1
    end

  end


  def persuade_stage_2

    @@current_flow = FLOWS.sample.freeze

    puts "response: #{@@current_flow}"

    @user.answers[:persuade_stage_1] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      @message.typing_on
      reply_back = Response.find_by(stage_id: 2, step_id: 1, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      reply_back = Response.find_by(stage_id: 2, step_id: 2, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      persuade_stage_qr_2 = UI::QuickReplies.build([YES.sample, 'TRUST'], [NO.sample, 'PERSUADE'])
      say HELP_PERSUADE_CTA.sample, quick_replies: persuade_stage_qr_2
      @message.typing_off

      next_command :persuade_stage_3
    else
      trust_stage_1

    end
  end
  def persuade_stage_3
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    @user.answers[:persuade_stage_2] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /no/i

      @message.typing_on
      reply_back = Response.find_by(stage_id: 3, step_id: 1, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      persuade_stage_qr_3 = UI::QuickReplies.build([YES.sample, 'TRUST'], [NO.sample, 'PERSUADE'])
      say HELP_PERSUADE_CTA.sample, quick_replies: persuade_stage_qr_3
      @message.typing_off


      next_command :persuade_stage_4
    else
      trust_stage_1
    end
  end
  def persuade_stage_4
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    @user.answers[:persuade_stage_3] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /no/i

      @message.typing_on
      sleep 2
      reply_back = Response.find_by(stage_id: 4, step_id: 1, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      sleep 2
      reply_back = Response.find_by(stage_id: 4, step_id: 2, flow_id: @@current_flow)
      say reply_back.response_content
      @message.typing_off

      @message.typing_on
      sleep 2
      persuade_stage_qr_3 = UI::QuickReplies.build([YES.sample, 'TRUST'], [NO.sample, 'PERSUADE'])
      say HELP_PERSUADE_CTA.sample, quick_replies: persuade_stage_qr_3
      @message.typing_off

      next_command :persuade_stage_5
    else
      trust_stage_1
    end
  end
  def persuade_stage_5
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    @user.answers[:persuade_stage_4] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /no/i

      @message.typing_on
      reply_back = Response.find_by(stage_id: 5, step_id: 1, flow_id: @@current_flow)
      say reply_back.response_content
            @message.typing_off

      @message.typing_on
      reply_back = Response.find_by(stage_id: 5, step_id: 2, flow_id: @@current_flow)
      UI::ImageAttachment.new(reply_back.response_content).send(@user)
      @message.typing_off

      @message.typing_on
      sleep 2
      persuade_stage_qr_3 = UI::QuickReplies.build([YES.sample, 'TRUST'], ['Quit', 'PERSUADE'])
      say HELP_PERSUADE_CTA.sample, quick_replies: persuade_stage_qr_3
      @message.typing_off
      next_command :persuade_unsuccessful
    else
      trust_stage_1
    end
  end
  def persuade_unsuccessful
    # Fallback functionality if stop word used or user input is not text
    fall_back && return
    @user.answers[:persuade_stage_5] = @message.text

    if @message.quick_reply == 'TRUST' || @message.text =~ /no/i
      trust_stage_1
    else
      @message.typing_on
      say '😭 Sorry to hear that!'
      @message.typing_off

      @message.typing_on
      persuade_stage_qr_fail = UI::QuickReplies.build(['No,I am good', 'NO_THANKS'])
      say 'Is there any questions that I can answer? Please type them.', quick_replies: persuade_stage_qr_fail
      @message.typing_off

      next_command :persuade_feedback
    end
  end
  def persuade_feedback
    fall_back && return
    @user.answers[:persuade_unsuccessful] = @message.text
    say 'Thanks for your feedback 🙏'

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
end
