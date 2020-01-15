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
  end
end
