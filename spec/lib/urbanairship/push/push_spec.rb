require 'spec_helper'

require 'urbanairship/push/push'
require 'urbanairship/push/payload'

include Urbanairship::Push
include Urbanairship::Push::Payload

describe Push do
  describe '#payload' do

    let!(:a_push) {
      p = Push.new(nil)
      p.audience = all_
      p.options = options(expiry: 10080)
      p.device_types = all_
      p.message = message(
        title: 'Title',
        body: 'Body',
        content_type: 'text/html',
        content_encoding: 'utf8',
        extra: { more: 'stuff' },
        expiry: 10080,
        icons: { list_icon: 'http://cdn.example.com/message.png' },
        options: { some_delivery_option: true }
      )
      p
    }

    let(:expected_message) {
      {
        title: 'Title',
        body: 'Body',
        content_type: 'text/html',
        content_encoding: 'utf8',
        extra: { more: 'stuff' },
        expiry: 10080,
        icons: { list_icon: 'http://cdn.example.com/message.png' },
        options: { some_delivery_option: true },
      }
    }

    it 'can build a full payload structure' do
      a_push.notification = notification(alert: 'Hello')
      expect(a_push.payload).to eq({
        notification: {alert: 'Hello'},
        audience: 'all',
        device_types: 'all',
        options: { expiry: 10080 },
        message: expected_message
      })
    end

    it 'can build a payload with actions' do
      a_push.notification = notification(
        alert: 'Hello',
        actions: actions(
          add_tag: 'new_tag',
          remove_tag: 'old_tag',
          share: 'Check out Urban Airship!',
          open_: {
              type: 'url',
              content: 'http://www.urbanairship.com'
          },
          app_defined: {some_app_defined_action: 'some_values'}
        )
      )
      expect(a_push.payload).to eq({
        notification: {
          alert: 'Hello',
          actions: {
            add_tag: 'new_tag',
            remove_tag: 'old_tag',
            share: 'Check out Urban Airship!',
            open: {
              type: 'url',
              content: 'http://www.urbanairship.com'
            },
            app_defined: {some_app_defined_action: 'some_values'}
          }},
        audience: 'all',
        device_types: 'all',
        options: { expiry: 10080 },
        message: expected_message
      })
    end

    it 'can build a payload with an interactive notification' do
      a_push.notification = notification(
        interactive: interactive(
          type: 'some_type',
          button_actions: {
            yes: {
              add_tag: 'clicked_yes',
              remove_tag: 'never_clicked_yes',
              open: {
                type: 'url',
                content: 'http://www.urbanairship.com'
              }
            },
            no: {
              add_tag: 'hater'
            }
          }
        )
      )
      expect(a_push.payload).to eq({
        notification: {
          interactive: {
            type: 'some_type',
            button_actions: {
              yes: {
                add_tag: 'clicked_yes',
                remove_tag: 'never_clicked_yes',
                open: {
                  type: 'url',
                  content: 'http://www.urbanairship.com'
                }
              },
              no: {
                add_tag: 'hater'
              }
            }
          }
        },
        audience: 'all',
        device_types: 'all',
        options: { expiry: 10080 },
        message: expected_message
      })
    end

  end
end
