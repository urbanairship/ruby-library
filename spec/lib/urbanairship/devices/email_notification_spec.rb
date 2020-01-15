require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/email_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

    email_override_payload = {"email": {
            'bcc': "example@fakeemail.com",
            'bypass_opt_in_level': false,
            'html_body': "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
            'message_type': "commercial",
            'plaintext_body': "Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]",
            'reply_to': "another_fake_email@domain.com",
            'sender_address': "team@urbanairship.com",
            'sender_name': "Airship",
            'subject': "Did you get that thing I sent you?"
          }}

    inline_template_payload = {"email": {
            'bcc': "example@fakeemail.com",
            'message_type': "commercial",
            'reply_to': "another_fake_email@domain.com",
            'sender_address': "team@urbanairship.com",
            'sender_name': "Airship",
            'template': {
                    'template_id': "9335bb2a-2a45-456c-8b53-42af7898236a",
                    "fields": {
                      'plaintext_body': "Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]",
                      'subject': "Did you get that thing I sent you?"
                    },
                    'variable_details': [
                      {
                          'key': 'name',
                          'default_value': 'hello'
                      },
                      {
                          'key': 'event',
                          'default_value': 'event'
                      }
                    ]
                  }
            }}

  describe Urbanairship::Devices::EmailNotification do

    describe '#email_override' do
      it 'can format email override correctly' do
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
        result = notification.email_override
        expect(result).to eq(email_override_payload)
      end
    end

    describe '#email_with_inline_template' do
      it 'can format email with inline template correctly' do
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
        result = notification.email_with_inline_template
        expect(result).to eq(inline_template_payload)
      end
    end

  end
end
