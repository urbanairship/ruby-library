require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  email_override_payload = {"email": {
         "subject": "Did you get that thing I sent you?",
         "html_body": "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
         "plaintext_body": "Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]",
         "message_type": "commercial",
         "sender_name": "Airship",
         "sender_address": "team@urbanairship.com",
         "reply_to": "no-reply@urbanairship.com"
      }}

  describe Urbanairship::Devices::Notification do
    describe '#email_override' do
      notification = ua.Notification.new(client: airship)
      notification.bcc = "example@fakeemail.com"
      notification.bypass_opt_in_level = false
      notification.html.body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
      notification.messsage_type = 'transactional'
      notification.reply_to = 'another_fake_email@domain.com'
      notification.sender_address = 'testymctestface@gmail.com'
      notifcation.subject = 'Did you get that thing I sent you?'
    end
  end
end
