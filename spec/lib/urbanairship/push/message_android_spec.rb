require 'spec_helper'

require 'urbanairship/push/payload'
include Urbanairship::Push::Payload

describe Urbanairship do
  describe '#notification' do
    context 'for Android' do

      it 'builds a notification' do
        payload = notification(android: android(
                                 alert: 'Hello',
                                 delay_while_idle: true,
                                 collapse_key: '123456',
                                 time_to_live: 100,
                                 extra: { more: 'stuff' },
                                 interactive: {
                                   type: 'a_type',
                                   button_actions: {
                                     yes: { add_tag: 'clicked_yes' },
                                     no: { add_tag: 'clicked_no' }
                                 }}))
        expect(payload).to eq({
                                android: {
                                  alert: 'Hello',
                                  delay_while_idle: true,
                                  collapse_key: '123456',
                                  time_to_live: 100,
                                  extra: { more: 'stuff' },
                                  interactive: {
                                    type: 'a_type',
                                    button_actions: {
                                      yes: { add_tag: 'clicked_yes' },
                                      no: { add_tag: 'clicked_no' }
                                    }
                                  }
                                }})
      end

    end
  end
end
