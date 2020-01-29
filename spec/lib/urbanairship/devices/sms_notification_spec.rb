require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/sms_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  sms_override = {
    "alert": "A generic alert sent to all platforms without overrides in device_types",
       "sms": {
          "alert": "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters",
          "expiry": 172800,
          "shorten_links": true
       }
  }

  sms_template_with_fields = {
    "sms": {
      "template": {
        "fields": {
          "alert": "Hi, {{customer.first_name}}, your {{#each cart}}{{this.name}}{{/each}} are ready to pickup at our {{customer.location}} location!"
        }
      }
    }
  }

  sms_template_with_id = {
    "sms": {
      "template": {
        "template_id": "9335bb2a-2a45-456c-8b53-42af7898236a"
      }
    }
  }

  describe Urbanairship::Devices::SmsNotification do

    describe '#sms_notification_override' do
      it 'can format sms notification override correctly' do
        notification = UA::SmsNotification.new(client: airship)
        notification.sms_alert = "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters"
        notification.generic_alert = "A generic alert sent to all platforms without overrides in device_types"
        notification.expiry = 172800
        notification.shorten_links = true
        result = notification.sms_notification_override
        expect(result).to eq(sms_override)
      end
    end

    describe '#sms_inline_template' do
      it 'can format sms inline templates correctly' do
        notification = UA::SmsNotification.new(client: airship)
        notification.sms_alert = "Hi, {{customer.first_name}}, your {{#each cart}}{{this.name}}{{/each}} are ready to pickup at our {{customer.location}} location!"
        result = notification.sms_inline_template
        expect(result).to eq(sms_template_with_fields)
      end

      it 'can format sms inline templates id correctly' do
        notification = UA::SmsNotification.new(client: airship)
        notification.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        result = notification.sms_inline_template
        expect(result).to eq(sms_template_with_id)
      end
    end
  end
end
