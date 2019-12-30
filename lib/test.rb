irb -I .

require 'urbanairship'

UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.bypass_opt_in_level = false
email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
email_notification.message_type = 'transactional'
email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
email_notification.reply_to = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_address = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_name = 'Goat Tester'
email_notification.subject = 'Did you get that thing I sent you?'
override = email_notification.email_override

create_and_send = UA::CreateAndSend.new(client: airship)
create_and_send.addresses = [
  {
    "ua_address": "sarah.kirk@airship.com",
    "ua_commercial_opted_in": "2019-12-29T10:34:22",
  }
]
create_and_send.device_types = [ "email" ]
create_and_send.campaigns = ["winter sale", "west coast"]
create_and_send.notification = email_notification
