require 'spec_helper'

require 'urbanairship/push/push'
require 'urbanairship/push/payload'

include Urbanairship::Push
include Urbanairship::Push::Payload

describe Urbanairship::Push do
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

  let(:default) {
    {
      audience: 'all',
      device_types: 'all',
      options: { expiry: 10080 },
      message: expected_message
    }
  }

  def payload_should_have(structure)
    actual_payload = a_push.payload
    expected_payload = default.merge(structure)
    expect(actual_payload).to eq(expected_payload)
  end


  describe Push do
    describe '#payload' do
      it 'can build a full payload structure' do
        a_push.notification = notification(alert: 'Hello')
        payload_should_have(notification: { alert: 'Hello' })
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
        payload_should_have(
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
              app_defined: {
                some_app_defined_action: 'some_values'
              }
            }
          }
        )
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
        payload_should_have(
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
          }
        )
      end

      it 'can handle an iOS alert key/value' do
        key_value = { foo: 'bar' }
        a_push.notification = notification(ios: ios(alert: key_value))
        a_push.device_types = 'ios'
        expect(a_push.payload).to eq(default.merge(
                                       {
                                         notification: {
                                           ios: {
                                             alert: key_value
                                           }
                                         },
                                         device_types: 'ios'
                                       }
        ))
      end

    end
  end
end
# describe ScheduledPush do
#   describe '#payload' do
#     it 'can build a scheduled payload'
#   end
# end
