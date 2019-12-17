require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::CreateAndSend do

    email_response = {
        "ok": true,
        "operation_id": "67c65146-c27f-431f-b54a-83aca694fdd3",
        "push_ids": [
            "c0eead17-333b-4f86-8a42-9fb7be1ed627"
        ],
        "message_ids": [],
        "content_urls": []
    }

    addresses = [
      {
        "ua_address": "new@email.com",
        "ua_commercial_opted_in": "2018-11-29T10:34:22",
      },
      {
        "ua_address": "ben@icetown.com",
        "ua_commercial_opted_in": "2018-11-29T12:45:10",
      }
    ]

    campaigns = {
        "categories": ["winter sale", "west coast"]
    }

    email_override_payload = {"email": {
            'bcc': "example@fakeemail.com",
            'bypass_opt_in_level': false,
            'html_body': "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
            'message_type': "commercial",
            'plaintext_body': "Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]",
            'reply-to': "another_fake_email@domain.com",
            'sender_address': "team@urbanairship.com",
            'sender_name': "Airship",
            'subject': "Did you get that thing I sent you?"
          }}

    describe '#create_and_send' do
      it 'creates and sends for email override' do
        notification = UA::Notification.new(client: airship)
        notification.bcc = "example@fakeemail.com"
        notification.bypass_opt_in_level = false
        notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
        notification.message_type = 'commercial'
        notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
        notification.reply_to = 'another_fake_email@domain.com'
        notification.sender_address = 'team@urbanairship.com'
        notification.sender_name = 'Airship'
        notification.subject = 'Did you get that thing I sent you?'
        override = notification.email_override

        create_and_send = US::CreateAndSend.new(client: airship)
        create_and_send.addresses = [
          {
            "ua_address": "new@email.com",
            "ua_commercial_opted_in": "2018-11-29T10:34:22",
          },
          {
            "ua_address" : "ben@icetown.com",
            "ua_commercial_opted_in": "2018-11-29T12:45:10",
          }
        ]
        create_and_send.device_types = [ "email" ]
        create_and_send.campaigns = ["winter sale", "west coast"]
        create_and_send.notification = override
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = create_and_send.create_and_send
        expect(actual_resp).to eq(email_response)
      end

    end

  end
end
