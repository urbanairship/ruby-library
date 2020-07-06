require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/email_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

    email_override_payload = {"email": {
            'bcc': "example@fakeemail.com",
            'html_body': "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>",
            'message_type': "commercial",
            'click_tracking': true,
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

    template_with_id_payload = {"email": {
            'bcc': "example@fakeemail.com",
            'message_type': "commercial",
            'reply_to': "another_fake_email@domain.com",
            'sender_address': "team@urbanairship.com",
            'sender_name': "Airship",
            'template': {
                    'template_id': "9335bb2a-2a45-456c-8b53-42af7898236a"
            }}
          }

  describe Urbanairship::Devices::EmailNotification do

    describe '#email_override' do
      it 'can format email override correctly' do
        notification = UA::EmailNotification.new(client: airship)
        notification.bcc = "example@fakeemail.com"
        notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
        notification.message_type = 'commercial'
        notification.click_tracking = true
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

      it 'formats email with template_id correctly' do 
        notification = UA::EmailNotification.new(client: airship)
        notification.bcc = "example@fakeemail.com"
        notification.message_type = 'commercial'
        notification.reply_to = 'another_fake_email@domain.com'
        notification.sender_address = 'team@urbanairship.com'
        notification.sender_name = 'Airship'
        notification.template_id = '9335bb2a-2a45-456c-8b53-42af7898236a'
        result = notification.email_with_inline_template
        expect(result).to eq(template_with_id_payload)
      end
              
    end

    describe '#define_template_object' do
      it 'formats the template object with template_id correctly' do 
        notification = UA::EmailNotification.new(client: airship)
        notification.template_id = '9335bb2a-2a45-456c-8b53-42af7898236a'
        result = notification.define_template_object
        expect(result).to eq({
          template_id: '9335bb2a-2a45-456c-8b53-42af7898236a'
        })
      end

      it 'formats template object with fields object correctly' do 
        notification = UA::EmailNotification.new(client: airship)
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
        result = notification.define_template_object 
        expect(result).to eq({
          fields: {
            subject: 'Did you get that thing I sent you?',
            plaintext_body: 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
          },
          variable_details: [
          {
              'key': 'name',
              'default_value': 'hello'
          },
          {
              'key': 'event',
              'default_value': 'event'
          }
         ]
        })
      end
    end

    describe '#define_fields' do
      it 'formats fields correctly with the correct values' do
        notification = UA::EmailNotification.new(client: airship)
        notification.subject = 'subject'
        notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]'
        result = notification.define_fields
        expect(result).to eq({
          'subject': 'subject',
          'plaintext_body': 'Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]'
                    })
      end

      it 'returns nil when subject is not set' do
        notification = UA::EmailNotification.new(client: airship)
        notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\\\"http://unsubscribe.urbanairship.com/email/success.html\\\"]]'
        result = notification.define_fields
        expect(result).to eq(nil)
      end

      it 'returns nil when plaintext_body is not set' do 
        notification = UA::EmailNotification.new(client: airship)
        notification.subject = 'subject'
        result = notification.define_fields
        expect(result).to eq(nil)
      end
    end

  end
end
