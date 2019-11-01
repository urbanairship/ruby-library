require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/email'
require 'urbanairship/devices/sms'

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
        "ua_address" : "ben@icetown.com",
        "ua_commercial_opted_in": "2018-11-29T12:45:10",
      }
    ]

    campaigns = {
        "categories": ["winter sale", "west coast"]
    }

    notification = {
      "email": {
        "subject": "Welcome to the Winter Sale! ",
        "html_body": "<h1>Seasons Greetings</h1><p>Check out our winter deals!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
        "plaintext_body": "Greetings! Check out our latest winter deals! [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]",
        "message_type": "commercial",
        "sender_name": "Airship",
        "sender_address": "team@urbanairship.com",
        "reply_to": "no-reply@urbanairship.com"
      }
    }

    describe '#email_channel' do
      it 'creates and sends to email channels' do
        cns_email = UA::CreateAndSend.new(client: airship)
        cns_email.addresses = addresses
        cns_email.create_and_send
        cns_email.campagins = campaigns
        cns_email.device_types = ['email']
        cns_email.notification = notification

        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = cns_email.email_channel
        expect(actual_resp).to eq(email_response)
      end
  end
end
