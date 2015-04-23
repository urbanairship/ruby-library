require 'spec_helper'

require 'urbanairship/push/payload'
include Urbanairship::Push::Payload

describe Urbanairship do
  describe '#notification' do
    it 'builds a simple alert' do
      expect(notification(alert: 'Hello')).to eq({ alert: 'Hello' })
    end

    # it 'builds an iOS notification' do
    #   payload = notificatiion(ios: ios(alert: 'Hello',
    #                                    badge: '+1',
    #                                    sound: 'cat.caf',
    #                                    extra: { more: 'stuff' },
    #                                    expiry: 'time',
    #                                    category: 'test',
    #                                    interactive: {
    #                                      type: 'a_type',
    #                                      button_actions: {
    #                                        yes: {
    #                                          add_tag: 'clicked_yes'
    #                                        },
    #                                        no: {
    #                                          add_tag: 'clicked_no'
    #                                        }
    #                                      }
    #                                    }
    #                                   )
    #                          )

    # end
  end
end
