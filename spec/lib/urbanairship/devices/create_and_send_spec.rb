require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/email_notification'

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

    # schedule_operation_response = {
    #   "ok": true,
    #   "operation_id": "67c65146-c27f-431f-b54a-83aca694fdd3",
    #   "schedule_urls": [
    #       "http://go.urbanairship/api/schedules/2d69320c-3c91-5241-fac4-248269eed109"
    #   ],
    #   "schedules": [
    #     {
    #       "url": "http://go.urbanairship/api/schedules/2d69320c-3c91-5241-fac4-248269eed109",
    #       "schedule": {
    #           "scheduled_time": "2018-11-11T12:00:00"
    #       },
    #       "push": {
    #         "audience": {
    #           "create_and_send": [
    #             {
    #               "ua_address": "new@email.com",
    #               "ua_commercial_opted_in": "2018-11-29T10:34:22",
    #             },
    #             {
    #               "ua_address": "ben@icetown.com",
    #               "ua_commercial_opted_in": "2018-11-29T12:45:10",
    #             }
    #           ]
    #         },
    #         "device_types": [ "email" ],
    #         "notification": {
    #           "email": {
    #             "subject": "Welcome to the Winter Sale! ",
    #             "html_body": "<h1>Seasons Greetings</h1><p>Check out our winter deals!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
    #             "plaintext_body": "Greetings! Check out our latest winter deals! [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]",
    #             "message_type": "commercial",
    #             "sender_name": "Airship",
    #             "sender_address": "team@urbanairship.com",
    #             "reply_to": "no-reply@urbanairship.com"
    #         },
    #         "campaigns": {
    #             "categories": ["winter sale", "west coast"]
    #           }
    #         }
    #       }
    #       "push_ids": ["8cf8b2a5-7655-40c2-a500-ff498e60453e"]
    #     }
    #   ]
    # }


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
