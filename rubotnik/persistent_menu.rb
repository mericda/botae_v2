# rubocop:disable all
module Rubotnik
  # Enables persistent menu for your bot
=begin
  class PersistentMenu
    def self.enable
      # Design your persistent menu here:
      Facebook::Messenger::Profile.set({
        persistent_menu: [
          {
            locale: 'default',
            # If this option is set to true,
            # user will only be able to interact with bot
            # through the persistent menu
            # (composing a message will be disabled)
            composer_input_disabled: false,
            call_to_actions: [
              {
                type: 'postback',
                title: 'Best food or coffee nearby',
                payload: 'TRUST_PRESTAGE_1'
              },
              {
                type: 'postback',
                title: 'Places popular among friends',
                payload: 'TRUST_PRESTAGE_4'
              }
=begin
              {
                type: 'nested',
                title: 'Info',
                call_to_actions: [
                  {
                    title: 'Get a Gif',
                    type: 'postback',
                    payload: 'HAVEAGIF'
                  },

                ]
              }
=end
            ]
          }
        ]
        }, access_token: ENV['ACCESS_TOKEN'])
    end
  end
=end
end
