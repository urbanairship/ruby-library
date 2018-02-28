require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Push do
  UA = Urbanairship

  let(:some_expiry) { 10_080 }

  example_hash = {
      "body" => {
          "ok" => "true",
          "push_ids" => ["04fca66c-f33a-11e4-9c82-5ff5f086852f"],
          "schedule_urls" => ["https://go.urbanairship.com/api/schedules/0492662a-1b52-4343-a1f9-c6b0c72931c0"]
      },
      "code" => "200",
      "headers" => {
          "content_type"=>"application/vnd.urbanairship+json;version=3",
          "data_attribute"=>"named_user",
          "cache_control"=>"max-age=0",
          "expires"=>"Fri, 21 Oct 2016 17:52:29 GMT",
          "last_modified"=>"Fri, 21 Oct 2016 17:52:29 GMT",
          "vary"=>"Accept-Encoding, User-Agent",
          "content_encoding"=>"gzip",
          "content_length"=>"802",
          "date"=>"Fri, 21 Oct 2016 17:52:29 GMT",
          "connection"=>"keep-alive"
      }
  }

  let(:simple_http_response) { example_hash }

  let!(:a_push) {
    p = UA::Push::Push.new(nil)
    p.audience = UA.all
    p.options = UA.options(expiry: some_expiry)
    p.device_types = UA.all
    p.message = UA.message(
        title: 'Title',
        body: 'Body',
        content_type: 'text/html',
        content_encoding: 'utf8',
        extra: { more: 'stuff' },
        expiry: some_expiry,
        icons: { list_icon: 'http://cdn.example.com/message.png' },
        options: { some_delivery_option: true }
    )
    p.in_app = UA.in_app(
        alert: 'Hello',
        display_type: 'banner',
        display: 'top',
        expiry: 0,
        actions: { add_tag: 'in_app' },
        interactive: {
            type: 'a_type',
            button_actions: {
                yes: { add_tag: 'clicked_yes' },
                no: { add_tag: 'clicked_no' }
            }},
        extra: { more: 'stuff' }
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
        },
        in_app: {
        alert: 'Hello',
        display_type: 'banner',
        display: 'top',
        expiry: 0,
        actions: { add_tag: 'in_app' },
        interactive: {
            type: 'a_type',
            button_actions: {
                yes: { add_tag: 'clicked_yes' },
                no: { add_tag: 'clicked_no' }
            }},
        extra: { more: 'stuff' }
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


  describe Urbanairship::Push do
    describe '#payload' do
      it 'can build a full payload structure' do
        a_push.notification = UA.notification(alert: 'Hello')
        expect_payload_to_have(notification: { alert: 'Hello' })
      end

      it 'can build a payload with actions' do
        a_push.notification = UA.notification(
            alert: 'Hello',
            actions: UA.actions(
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
        a_push.notification = UA.notification(
            interactive: UA.interactive(
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
        a_push.notification = UA.notification(ios: UA.ios(alert: key_value))
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
      it 'can be invoked and parse the "ok" value' do
        airship = UA::Client.new(key: '123', secret: 'abc')
        allow(airship)
            .to receive(:send_request)
                    .and_return(simple_http_response)
        a_push.client = airship

        push_response = a_push.send_push
        expect(push_response.ok).to eq 'true'
      end

      it 'returns the push ids' do
        airship = UA::Client.new(key: '123', secret: 'abc')
        allow(airship)
            .to receive(:send_request)
                    .and_return(simple_http_response)
        a_push.client = airship

        push_response = a_push.send_push
        expect(push_response.push_ids)
            .to eq ['04fca66c-f33a-11e4-9c82-5ff5f086852f']
      end

      it 'sends a scheduled push' do
        SCHEDULE_URL = 'https://go.urbanairship.com/api/schedules/0492662a-1b52-4343-a1f9-c6b0c72931c0'
        airship = UA::Client.new(key: '123', secret: 'abc')
        allow(airship)
            .to receive(:send_request)
                    .and_return(simple_http_response)
        a_push.client = airship

        scheduled_push = UA::Push::ScheduledPush.new(airship)
        scheduled_push.push = a_push
        scheduled_push.schedule = UA.scheduled_time(Time.now)
        scheduled_push.send_push

        expect(scheduled_push.url)
            .to eq SCHEDULE_URL
      end
    end
  end


  describe Urbanairship::Push::ScheduledPush do
    describe '#from_url' do
      it 'loads an existing scheduled push from its URL' do
        mock_response = {
          'body' => {
            'name' => 'a schedule',
            'schedule' => { 'scheduled_time' => '2013-07-15T18:40:20' },
            'push' => {
              'audience' => 'all',
              'notification' => { 'alert' => 'Hello' },
              'device_types' => 'all',
              'options' => { 'expiry' => some_expiry },
              'message' => {
                'title' => 'Title',
                'body' => 'Body',
                'content_type' => 'text/html',
                'content_encoding' => 'utf8'
              }
            }
          }
        }
        airship = UA::Client.new(key: '123', secret: 'abc')
        allow(airship)
            .to receive(:send_request)
                    .and_return(mock_response)
        a_push.client = airship

        lookup_url = 'https://go.urbanairship.com/api/schedules/0492662a-1b52-4343-a1f9-c6b0c72931c0'
        scheduled_push = UA::Push::ScheduledPush.from_url(
            client: airship,
            url: lookup_url
        )
        expect(scheduled_push.push.device_types).to eq 'all'
      end
    end

    describe '#cancel' do
      it 'fails without a URL' do
        airship = UA::Client.new(key: '123', secret: 'abc')
        scheduled_push = UA::Push::ScheduledPush.new(airship)
        expect {
          scheduled_push.cancel
        }.to raise_error(ArgumentError)
      end

      it 'succeeds with a URL' do
        lookup_url = 'https://go.urbanairship.com/api/schedules/0492662a-1b52-4343-a1f9-c6b0c72931c0'
        airship = UA::Client.new(key: '123', secret: 'abc')
        allow(airship)
            .to receive(:send_request)
                    .and_return('')

        scheduled_push = UA::Push::ScheduledPush.new(airship)
        scheduled_push.url = lookup_url
        expect {
          scheduled_push.cancel
        }.not_to raise_error
      end
    end

    describe '#update' do
      it 'fails without a URL' do
        airship = UA::Client.new(key: '123', secret: 'abc')
        scheduled_push = UA::Push::ScheduledPush.new(airship)
        expect {
          scheduled_push.update
        }.to raise_error(ArgumentError)
      end
    end

    describe '#payload' do
      let(:a_time)         { Time.new(2013, 1, 1, 12, 56) }
      let(:a_time_in_text) { '2013-01-01T12:56:00' }
      let(:a_name)         { 'This Schedule' }
      let(:scheduled_push) {
        sched = UA::Push::ScheduledPush.new(nil)
        sched.push = a_push
        sched.name = a_name
        sched
      }

      it 'can build a scheduled payload' do
        scheduled_push.schedule = UA.scheduled_time(a_time)
        expect(scheduled_push.payload).to eq(
                                              schedule: { scheduled_time: a_time_in_text },
                                              name: a_name,
                                              push: default_expected_payload
                                          )
      end

      it 'can build a local scheduled payload' do
        scheduled_push.schedule = UA.local_scheduled_time(a_time)
        expect(scheduled_push.payload).to eq(
                                              schedule: { local_scheduled_time: a_time_in_text },
                                              name: a_name,
                                              push: default_expected_payload
                                          )
      end
    end

    describe '#list' do
      airship = UA::Client.new(key: '123', secret: 'abc')
      scheduled_push = UA::Push::ScheduledPush.new(airship)

      it 'returns a specific schedule successfully' do
        expected_resp = {
            'body' => {
                'name' => 'name',
                'schedule' => { 'scheduled_time' => '2015-08-01' },
                'push' => {
                    'audience' => 'all',
                    'notification' => { 'alert' => 'Hello' },
                    'device_types' => 'all'
                }
            },
            'code' => 200
        }
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = scheduled_push.list(schedule_id: 'schedule_id')
        expect(actual_resp).to eq(expected_resp)
      end

      it 'fails when schedule_id is not a string' do
        expect {
          scheduled_push.list(schedule_id: 123)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe Urbanairship::Push::ScheduledPushList do
    schedule_item = {
        'url' => 'url',
        'schedule' => { 'scheduled_time' => '2015-08-01' },
        'push' => {
            'audience' => 'all',
            'notification' => { 'alert' => 'Hello' },
            'device_types' => 'all'
        }
    }
    expected_resp = {
        'body' => {
            'schedules' => [schedule_item, schedule_item, schedule_item],
            'next_page' => 'url'
        },
        'code' => 200
    }
    expected_resp_next = {
        'body' => {
            'schedules' => [schedule_item, schedule_item, schedule_item],
        },
        'code' => 200
    }
    airship = UA::Client.new(key: '123', secret: 'abc')
    it 'iterates correctly over the schedule list' do
      allow(airship).to receive(:send_request).and_return(expected_resp, expected_resp_next)
      schedule_list = UA::ScheduledPushList.new(client: airship)
      instantiated_list = Array.new
      schedule_list.each do |schedule|
        expect(schedule).to eq(schedule_item)
        instantiated_list.push(schedule)
      end
      expect(instantiated_list.size).to eq(6)
    end
  end

  describe Urbanairship::Push::PushResponse do
    describe '#ok' do
      it 'presents the ok message from the response' do
        pr = UA::Push::PushResponse.new(http_response_body: simple_http_response['body'], http_response_code:simple_http_response['code'])
        expect(pr.ok).to eq 'true'
      end

      it 'is read-only' do
        pr = UA::Push::PushResponse.new(http_response_body: simple_http_response['body'], http_response_code:simple_http_response['code'])
        expect {
          pr.ok = 'no'
        }.to raise_error(NoMethodError)
      end

      it 'allows nil' do
        expect {
          UA::Push::PushResponse.new(http_response_body: '{}', http_response_code: '{}').ok
        }.not_to raise_error
      end

      it 'allows an empty string' do
        expect {
          UA::Push::PushResponse.new(http_response_body: '').ok
        }.not_to raise_error
      end
    end
  end
end