require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
notification = UA::SmsNotification.new(client: airship)
notification.sms_alert = "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters"
notification.generic_alert = "A generic alert sent to all platforms without overrides in device_types"
notification.expiry = 172800
notification.shorten_links = true
override = notification.sms_notification_override
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_msisdn": "19703266269",
    "ua_sender": "18587323363",
    "ua_opted_in": "2020-01-23T18:45:30"
  }
]
send_it.device_types = [ "sms" ]
send_it.notification = override
send_it.campaigns = ["winter sale", "west coast"]
send_it.create_and_send

#send_it.payload
