require 'spec_helper'

# TODO: Think about the module / namespace setup. Then
#       modify specs to run without the `include` statements.
require 'urbanairship/airship'
require 'urbanairship/push/push'
require 'urbanairship/push/payload'
require 'urbanairship/push/schedule'

include Urbanairship::Push
include Urbanairship::Push::Payload
include Urbanairship::Push::Schedule


describe Urbanairship::Push do
  UA = Urbanairship

  let(:some_expiry) { 10_080 }
  let(:simple_http_response) { 
    '{"ok":"yes", "push_ids":["04fca66c-f33a-11e4-9c82-5ff5f086852f"]}' 
  }

  let!(:a_push) {
    p = Push.new(nil)
    p.audience = all_
    p.options = options(expiry: some_expiry)
    p.device_types = all_
    p.message = message(
      title: 'Title',
      body: 'Body',
      content_type: 'text/html',
      content_encoding: 'utf8',
      extra: { more: 'stuff' },
      expiry: some_expiry,
      icons: { list_icon: 'http://cdn.example.com/message.png' },
      options: { some_delivery_option: true }
    )
    p
  }

  let(:default_expected_payload) {
    {
      audience: 'all',
      device_types: 'all',
      options: { expiry: some_expiry },
      message: {
        title: 'Title',
        body: 'Body',
        content_type: 'text/html',
        content_encoding: 'utf8',
        extra: { more: 'stuff' },
        expiry: some_expiry,
        icons: { list_icon: 'http://cdn.example.com/message.png' },
        options: { some_delivery_option: true }
      }

    }
  }

  # True if the current (actual) `a_push.payload` is the same
  # as the default payload with the addition of the given
  # `additional_structure`.
  def expect_payload_to_have(additional_structure)
    actual_payload = a_push.payload
    expected_payload = default_expected_payload.merge(additional_structure)
    expect(actual_payload).to eq(expected_payload)
  end


  describe Push do
    describe '#payload' do
      it 'can build a full payload structure' do
        a_push.notification = notification(alert: 'Hello')
        expect_payload_to_have(notification: { alert: 'Hello' })
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
            app_defined: { some_app_defined_action: 'some_values' }
          )
        )
        expect_payload_to_have(
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
        expect_payload_to_have(
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

        expect_payload_to_have(
          notification: {
            ios: {
              alert: key_value
            }
          },
          device_types: 'ios'
        )
      end
    end

    describe '#send_push' do
      it 'can be invoked and parse a response' do
        a_push.airship = UA::Airship.new(key: '123', secret: 'abc')
        # a_push.airship = double(send_request: simple_http_response)

        push_response = a_push.send_push
        expect(push_response.ok).to eq 'yes'
      end

      it 'returns the push ids' do
        mock_response = JSON.dump({push_ids: ['0492662a-1b52-4343-a1f9-c6b0c72931c0']})
        airship = double(send_request: mock_response)
        a_push.airship = airship

        push_response = a_push.send_push
        expect(push_response.push_ids).to eq ['0492662a-1b52-4343-a1f9-c6b0c72931c0']
      end
    end
  end


  describe ScheduledPush do
    describe '#payload' do
      let(:a_time)         { DateTime.new(2013, 1, 1, 12, 56) }
      let(:a_time_in_text) { '2013-01-01T12:56:00' }
      let(:a_name)         { 'This Schedule' }
      let(:scheduled_push) {
        sched = ScheduledPush.new(nil)
        sched.push = a_push
        sched.name = a_name
        sched
      }

      it 'can build a scheduled payload' do
        scheduled_push.schedule = scheduled_time(a_time)
        expect(scheduled_push.payload).to eq(
          {
            schedule: { scheduled_time: a_time_in_text },
            name: a_name,
            push: default_expected_payload
          }
        )
      end

      it 'can build a local scheduled payload' do
        scheduled_push.schedule = local_scheduled_time(a_time)
        expect(scheduled_push.payload).to eq(
          {
            schedule: { local_scheduled_time: a_time_in_text },
            name: a_name,
            push: default_expected_payload
          }
        )
      end
    end
  end


  describe PushResponse do
    let (:simple_http_response) { '{"ok":"yes"}' }

    describe '#ok' do
      it 'presents the ok message from the response' do
        pr = PushResponse.new(http_response_body: simple_http_response)
        expect(pr.ok).to eq 'yes'
      end

      it 'is read-only' do
        pr = PushResponse.new(http_response_body: simple_http_response)
        expect {
          pr.ok = 'no'
        }.to raise_error(NoMethodError)
      end

      it 'allows nil' do
        expect {
          PushResponse.new(http_response_body: '{}').ok
        }.not_to raise_error
      end
    end
  end

end
