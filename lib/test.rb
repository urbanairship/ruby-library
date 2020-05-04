require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
email_notification.message_type = 'commercial'
email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
email_notification.reply_to = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_address = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_name = 'Goat Tester'
email_notification.subject = 'Did you get that thing I sent you?'
override = email_notification.email_override
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_address": "<your work email>",
    "ua_commercial_opted_in": "2019-12-29T10:34:22"
  }
]
send_it.device_types = [ "email" ]
send_it.campaigns = ["winter sale", "west coast"]
send_it.notification = email_notification.email_override
send_it.create_and_send


curl https://go.urbanairship.com/api/create-and-send/ -X POST -u "ISex_TTJRuarzs9-o_Gkhg:bF-7RuUzTxy0VzbHLu5mkQ" -d 
'{"audience": {"create_and_send": 
[{"ua_address": "sarah.kirk@airship.com","ua_commercial_opted_in": "2019-12-29T10:34:22"}]},
"notification": {"email":{"html_body": 
"<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
"message_type": "commercial",
"plaintext_body": "Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]",
"reply_to": "ua@sparkpost-staging.urbanairship.com",
"sender_address": "ua@sparkpost-staging.urbanairship.com",
"sender_name": "Goat Tester",
"subject": "Did you get that thing I sent you?"}},
"device_types": ["email"],
"campaigns": {"categories": ["winter sale", "west coast"]}}'

{:email=>
  {:bcc=>"example@fakeemail.com",
   :bypass_opt_in_level=>false,
   :html_body=>
    "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
   :message_type=>"commercial",
   :plaintext_body=>"Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]",
   :reply_to=>"another_fake_email@domain.com",
   :sender_address=>"team@urbanairship.com",
   :sender_name=>"Airship",
   :subject=>"Did you get that thing I sent you?"}}