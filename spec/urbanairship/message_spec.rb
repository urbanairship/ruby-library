require 'spec_helper'

require 'urbanairship/push/payload'
include Urbanairship::Push::Payload

describe Urbanairship do
  describe '#notification' do
    it 'builds a simple alert' do
      expect(notification(alert: 'Hello')).to eq alert: 'Hello'
    end

    context 'for iOS' do
      it 'builds a notification' do
        payload = notification(ios: ios(
                                 alert: 'Hello',
                                 badge: '+1',
                                 sound: 'cat.caf',
                                 extra: { more: 'stuff' },
                                 expiry: 'time',
                                 category: 'test',
                                 interactive: {
                                   type: 'a_type',
                                   button_actions: {
                                     yes: { add_tag: 'clicked_yes' },
                                     no: { add_tag: 'clicked_no' }
                                   }
        }))
        expect(payload).to eq({
                                ios: {
                                  alert: 'Hello',
                                  badge: '+1',
                                  sound: 'cat.caf',
                                  extra: { more: 'stuff' },
                                  expiry: 'time',
                                  category: 'test',
                                  interactive: {
                                    type: 'a_type',
                                    button_actions: {
                                      yes: { add_tag: 'clicked_yes' },
                                      no: { add_tag: 'clicked_no' }
                                    }
                                  }
                                }
        })
      end

      it 'builds a notification with a key/value alert' do
        payload = notification(ios: ios(
                                 alert: { foo: 'bar' },
                                 badge: '+1',
                                 sound: 'cat.caf',
                                 extra: { more: 'stuff' },
                                 expiry: 'time',
                                 category: 'test',
                                 interactive: {
                                   type: 'a_type',
                                   button_actions: {
                                     yes: { add_tag: 'clicked_yes' },
                                     no: { add_tag: 'clicked_no' }
                                   }
        }))
        expect(payload).to eq({
                                ios: {
                                  alert: { foo: 'bar' },
                                  badge: '+1',
                                  sound: 'cat.caf',
                                  extra: { more: 'stuff' },
                                  expiry: 'time',
                                  category: 'test',
                                  interactive: {
                                    type: 'a_type',
                                    button_actions: {
                                      yes: { add_tag: 'clicked_yes' },
                                      no: { add_tag: 'clicked_no' }
                                    }
                                  }
                                }})
      end

      it 'can handle Unicode' do
        message = notification(ios: ios(alert: 'Paß auf!'))
        expect(message).to eq ios: { alert: 'Paß auf!' }
      end

      it 'handles the "content-available" attribute properly' do
        message = notification(ios: ios(content_available: true))
        expect(message).to eq ios: { 'content-available' => true }
      end
    end
  end
end
