require 'spec_helper'

require 'urbanairship/push/payload'
include Urbanairship::Push::Payload

describe Urbanairship do
  describe '#notification' do
    it 'builds a simple alert' do
      expect(notification(alert: 'Hello')).to eq alert: 'Hello'
    end


    context 'Android' do
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


    context 'iOS' do
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


    context 'Amazon' do
      it 'builds a notification' do
        payload = notification(amazon: amazon(
                                 alert: 'Hello',
                                 title: 'My Title',
                                 consolidation_key: '123456',
                                 expires_after: 100,
                                 summary: 'Summary of the message',
                                 extra: { more: 'stuff' },
                                 interactive: {
                                   type: 'a_type',
                                   button_actions: {
                                     yes: { add_tag: 'clicked_yes' },
                                     no: { add_tag: 'clicked_no' }
                                 }}))
        expect(payload).to eq({
                                amazon: {
                                  alert: 'Hello',
                                  title: 'My Title',
                                  consolidation_key: '123456',
                                  expires_after: 100,
                                  summary: 'Summary of the message',
                                  extra: { more: 'stuff' },
                                  interactive: {
                                    type: 'a_type',
                                    button_actions: {
                                      yes: { add_tag: 'clicked_yes' },
                                      no: { add_tag: 'clicked_no' }
                                }}}})
      end
    end


    context 'Blackberry' do
      it 'sends "alerts" as plain text' do
        payload = notification(blackberry: blackberry(alert: 'Hello'))
        expect(payload).to eq blackberry: { body: 'Hello', content_type: 'text/plain' }
      end

      it 'can send html' do
        payload = notification(blackberry: blackberry(
                                              body: 'Hello',
                                              content_type: 'text/html'
                                              ))
        expect(payload).to eq blackberry: { body: 'Hello', content_type: 'text/html' }
      end
    end


    context 'WNS' do
      it 'can send a simple "alert"' do
        payload = notification(wns: wns_payload(alert: 'Hello'))
        expect(payload).to eq wns: { alert: 'Hello' }
      end

      it 'can send a key/value "toast"' do
        payload = notification(wns: wns_payload(toast: { a_key: 'a_value' }))
        expect(payload).to eq wns: { toast: { a_key: 'a_value' } }
      end
    end

  end
end
