require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/create_and_send'
require 'urbanairship/devices/notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

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

  describe Urbanairship::Devices::Notification do

    describe '#email_override' do
      it 'can format email override correctly' do
        notification = UA::Notification.new(client: airship)
        notification.bcc = "example@fakeemail.com"
        notification.bypass_opt_in_level = false
        notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
        notification.message_type = 'commercial'
        notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
        notification.reply_to = 'another_fake_email@domain.com'
        notification.sender_address = 'team@urbanairship.com'
        notification.sender_name = 'Airship'
        notification.subject = 'Did you get that thing I sent you?'
        result = notification.email_override
        expect(result).to eq(email_override_payload)
      end
    end

    describe '#email_with_inline_template' do
      it 'can format email with inline template correctly' do
        notification = UA::Notification.new(client: airship)
      end
    end
  end
end
