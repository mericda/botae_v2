# Showcases a chained sequence of commands that gather the data
# and store it in the answers hash inside the User instance.
module Persuade
  # State 'module_function' before any method definitions so
  # commands are mixed into Dispatch classes as private methods.
  module_function

  PERSUADE_STAGE_1_1_PHRASES = ["I\'m a bot that searches the best places nearby on Yelp, Facebook, Foursquare. For now, I can only search food or coffee places.","Need something to eat 🍱 or drink ☕️? I am the one who will find the best place. "]
  PERSUADE_STAGE_1_2_PHRASES = ["I try to understand the context, in this case where you are, and navigate you in the overcrowded food and coffee scene.","I use data to better understand the context,and suggest personalized places to check out."]
  PERSUADE_STAGE_2_1_PHRASES = ["Why Botae? Botae is its designer\'s early exploration of how Messenger bots can interact with users.","The idea of Botae came from its designer\'s own need of finding that best place to eat nearby."]
  PERSUADE_STAGE_2_2_PHRASES = ["Botae answers the question of \'Where should I eat now?\'","Botae is a bot, because you don\'t need another app in your phone, right?"]
  PERSUADE_STAGE_3_1_PHRASES = ["I\'m designed by Meric Dagli, who is a graduate interaction design student at Carnegie Mellon University.","I\'m designed by Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from 🇹🇷","My father is Meriç Dağlı, who is a graduate interaction design student at Carnegie Mellon University.","My father is Meric Dagli, an interaction design student from Carnegie Mellon University.","My father is Meric Dagli, a graduate interaction design student at Carnegie Mellon University, who is originally from Turkey."]
  PERSUADE_STAGE_3_2_PHRASES = []
  PERSUADE_STAGE_4_1_PHRASES = ["In addition, I may also find places among your Facebook Friends by running a similarity-based classification algorithm.","In addition, I may also find places among your Facebook Friends by running a smart algorithm."]
  PERSUADE_STAGE_4_2_PHRASES = ["I said \'I may find it\' is because I cannot always read data of your friends, or simply there is not enough data.","I said \'I may find it\' is because I cannot always read data of your friends."]
  PERSUADE_STAGE_5_1_PHRASES = ["Want to see some suggestions before you try? Here is a screenshot of one of my earlier suggestions.","Not sure about trying me? Here is an example suggestion."]
  PERSUADE_STAGE_5_2_PHRASES = ["http://mericdagli.com/botae/p1.jpg","http://mericdagli.com/botae/p2.jpg"]
  FLOWS = [1,2]


  def persuade_stage_1


    @@current_flow = FLOWS.sample.freeze
puts "#{@@current_flow}"

    @user.answers[:persuade_stage_1] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      @message.typing_on
      say PERSUADE_STAGE_1_1_PHRASES[@@current_flow]
      @message.typing_off

      @message.typing_on
      sleep 2
      say PERSUADE_STAGE_1_2_PHRASES[@@current_flow]
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



    @user.answers[:persuade_stage_1] = @message.text

    if @message.quick_reply == 'PERSUADE' || @message.text =~ /yes/i
      @message.typing_on
      say PERSUADE_STAGE_2_1_PHRASES[@@current_flow]
      @message.typing_off

      @message.typing_on
      sleep 2
      say PERSUADE_STAGE_2_2_PHRASES[@@current_flow]
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
      sleep 2
      say PERSUADE_STAGE_3_1_PHRASES[@@current_flow]
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
      say PERSUADE_STAGE_4_1_PHRASES[@@current_flow]
      @message.typing_off

      @message.typing_on
      sleep 2
      say PERSUADE_STAGE_4_2_PHRASES[@@current_flow]
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
      say PERSUADE_STAGE_5_1_PHRASES[@@current_flow]
      @message.typing_off

      @message.typing_on
      UI::ImageAttachment.new(PERSUADE_STAGE_5_2_PHRASES[@@current_flow]).send(@user)
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
      sleep 1
      say '😭 Sorry to hear that!'
      @message.typing_off

      @message.typing_on
      sleep 2
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
