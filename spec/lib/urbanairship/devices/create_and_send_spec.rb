require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/email_notification'
require 'urbanairship/devices/open_channel'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')


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

    sms_override_payload = {
      "audience": {
        "create_and_send": [
          {
            "ua_msisdn": "15558675309",
            "ua_sender": "12345",
            "ua_opted_in": "2018-11-11T18:45:30"
          }
        ]
      },
      "device_types": [ "sms" ],
      "notification": {
        "sms": {
          "alert": "Check out our winter sale! https://www.mysite.com/amazingly/long/url-that-I-want-to-shorten",
          "expiry": 172800,
          "shorten_links": true
        }
      },
      "campaigns": {
          "categories": ["winter sale", "west coast"]
      }
    }

    validation_response = {
       "ok": true
    }

  describe Urbanairship::Devices::CreateAndSend do

    describe '#create_and_send' do
      #create and send for email
      it 'creates and sends for email override' do
        notification = UA::EmailNotification.new(client: airship)
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

        create_and_send = UA::CreateAndSend.new(client: airship)
        create_and_send.addresses = [
          {
            "ua_address": "new@email.com",
            "ua_commercial_opted_in": "2018-11-29T10:34:22",
          },
          {
            "ua_address": "ben@icetown.com",
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

      it 'creates and sends for email inline template' do
        notification = UA::EmailNotification.new(client: airship)
        notification.bcc = "example@fakeemail.com"
        notification.message_type = 'commercial'
        notification.reply_to = 'another_fake_email@domain.com'
        notification.sender_address = 'team@urbanairship.com'
        notification.sender_name = 'Airship'
        notification.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
        notification.subject = 'Did you get that thing I sent you?'
        notification.variable_details = [
          {
              'key': 'name',
              'default_value': 'hello'
          },
          {
              'key': 'event',
              'default_value': 'event'
          }
        ]
        inline_template = notification.email_with_inline_template

        create_and_send = UA::CreateAndSend.new(client: airship)
        create_and_send.device_types = [ "email" ]
        create_and_send.addresses = [
          {
            "ua_address": "new@email.com",
            "ua_commercial_opted_in": "2018-11-29T10:34:22",
          },
          {
            "ua_address": "ben@icetown.com",
            "ua_commercial_opted_in": "2018-11-29T12:45:10",
          }
        ]
        create_and_send.campaigns = ["winter sale", "west coast"]
        create_and_send.notification = inline_template

        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = create_and_send.create_and_send
        expect(actual_resp).to eq(email_response)
      end

      it 'creates and sends for sms override' do
        notification = UA::SmsNotification.new(client: airship)
        notification.sms_alert = "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters"
        notification.generic_alert = "A generic alert sent to all platforms without overrides in device_types"
        notification.expiry = 172800
        notification.shorten_links = true
        override = notification.sms_notification_override
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_msisdn": "15558675309",
            "ua_sender": "12345",
            "ua_opted_in": "2018-11-11T18:45:30"
          }
        ]
        send_it.device_types = [ "sms" ]
        send_it.notification = override
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = send_it.create_and_send
        expect(actual_resp).to eq(email_response)
      end

      it 'creates and sends for sms notification with inline template' do
        notification = UA::SmsNotification.new(client: airship)
        notification.sms_alert = "Hi, {{customer.first_name}}, your {{#each cart}}{{this.name}}{{/each}} are ready to pickup at our {{customer.location}} location!"
        inline_template = notification.sms_inline_template
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_msisdn": "15558675309",
            "ua_sender": "12345",
            "ua_opted_in": "2018-11-11T18:45:30"
          }
        ]
        send_it.device_types = [ "sms" ]
        send_it.notification = inline_template
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = send_it.create_and_send
        expect(actual_resp).to eq(email_response)
      end

      it 'creates and sends for sms notification with inline template' do
        notification = UA::SmsNotification.new(client: airship)
        notification.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        inline_template = notification.sms_inline_template
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_msisdn": "15558675309",
            "ua_sender": "12345",
            "ua_opted_in": "2018-11-11T18:45:30"
          }
        ]
        send_it.device_types = [ "sms" ]
        send_it.notification = inline_template
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = send_it.create_and_send
        expect(actual_resp).to eq(email_response)
      end

      it 'creates and sends for open channels with template_id' do
        open_channel_notification = UA::OpenChannel.new(client:airship)
        open_channel_notification.open_platform = 'smart_fridge'
        open_channel_notification.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_address": "36d5a261-0454-40f5-b952-942c4b2b0f22",
            "name": "Perry"
          }
        ]
        send_it.device_types = [ 'open::smart_fridge' ]
        send_it.notification = open_channel_notification
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = send_it.create_and_send
      end

      it 'creates and sends for open channels with override' do
        open_channel_notification = UA::OpenChannel.new(client:airship)
        open_channel_notification.open_platform = 'smart_fridge'
        open_channel_notification.alert = 'a longer alert for users of smart fridges, who have more space.'
        open_channel_notification.media_attachment = 'https://example.com/cat_standing_up.jpeg'
        open_channel_notification.title = 'That\'s pretty neat!'
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_address": "36d5a261-0454-40f5-b952-942c4b2b0f22",
            "name": "Perry"
          }
        ]
        send_it.device_types = [ 'open::smart_fridge' ]
        send_it.notification = open_channel_notification.open_channel_override
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(email_response)
        actual_resp = send_it.create_and_send
      end
    end

    describe '#validate' do
      it 'will validate a payload for email override' do
        notification = UA::EmailNotification.new(client: airship)
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

        create_and_send = UA::CreateAndSend.new(client: airship)
        create_and_send.addresses = [
          {
            "ua_address": "new@email.com",
            "ua_commercial_opted_in": "2018-11-29T10:34:22",
          },
          {
            "ua_address": "ben@icetown.com",
            "ua_commercial_opted_in": "2018-11-29T12:45:10",
          }
        ]
        create_and_send.device_types = [ "email" ]
        create_and_send.campaigns = ["winter sale", "west coast"]
        create_and_send.notification = override

        allow(airship).to receive(:send_request).and_return(validation_response)
        actual_resp = create_and_send.validate
        expect(actual_resp).to eq(validation_response)
      end

      it 'will validate payload for sms override' do
        notification = UA::SmsNotification.new(client: airship)
        notification.sms_alert = "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters"
        notification.generic_alert = "A generic alert sent to all platforms without overrides in device_types"
        notification.expiry = 172800
        notification.shorten_links = true
        override = notification.sms_notification_override
        send_it = UA::CreateAndSend.new(client: airship)
        send_it.addresses = [
          {
            "ua_msisdn": "15558675309",
            "ua_sender": "12345",
            "ua_opted_in": "2018-11-11T18:45:30"
          }
        ]
        send_it.device_types = [ "sms" ]
        send_it.notification = override
        send_it.campaigns = ["winter sale", "west coast"]
        allow(airship).to receive(:send_request).and_return(validation_response)
        actual_resp = send_it.validate
        expect(actual_resp).to eq(validation_response)
      end
    end

  end

end
