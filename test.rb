#for template_id
require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.message_type = 'transactional'
email_notification.reply_to = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_address = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_name = 'Goat Tester'
email_notification.template_id = "6ce1800f-2e22-4ee9-8383-3d37f3adb429"
inline_template = email_notification.email_with_inline_template
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_address": "sarah.kirk@airship.com",
    "ua_commercial_opted_in": "2019-12-29T10:34:22"
  }
]
send_it.device_types = [ "email" ]
send_it.campaigns = ["winter sale", "west coast"]
send_it.notification = inline_template
send_it.create_and_send

#for template with inline template
require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'ISex_TTJRuarzs9-o_Gkhg', secret:'bF-7RuUzTxy0VzbHLu5mkQ')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.message_type = 'transactional'
email_notification.reply_to = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_address = 'ua@sparkpost-staging.urbanairship.com'
email_notification.sender_name = 'Goat Tester'
email_notification.subject= "Sarah is testing some stuff"
email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
inline_template = email_notification.email_with_inline_template
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_address": "sarah.kirk@airship.com",
    "ua_commercial_opted_in": "2019-12-29T10:34:22"
  }
]
send_it.device_types = [ "email" ]
send_it.campaigns = ["winter sale", "west coast"]
send_it.notification = inline_template
send_it.create_and_send

#full_payload
{:audience=>{:create_and_send=>[{:ua_address=>"sarah.kirk@airship.com", :ua_commercial_opted_in=>"2019-12-29T10:34:22"}]}, :device_types=>["email"], :notification=>{:email=>{:message_type=>"transactional", :reply_to=>"ua@sparkpost-staging.urbanairship.com", :sender_address=>"ua@sparkpost-staging.urbanairship.com", :sender_name=>"Goat Tester", :template=>{:fields=>{:plaintext_body=>"Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]", :subject=>"Sarah is testing some stuff"}}}}, :campaigns=>{:categories=>"@campaigns"}}
