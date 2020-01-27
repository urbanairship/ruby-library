require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/mms_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  mms_override_payload = {
  "mms": {
    "fallback_text": "Delivery failed, but you should still check this out.",
    "subject" : "Hey, thanks for subscribing!",
    "slides": [
      {
        "text": "Check this out!",
        "media": {
            "url": "https://i.imgur.com/1t466Om.jpg",
            "content_type": "image/jpeg",
            "content_length": 52918
          }
        }
      ]
    }
  }

  mms_template_with_id = {
    "mms" : {
      "template" : {
        "template_id" : "9335bb2a-2a45-456c-8b53-42af7898236a"
      }
    }
  }

  mms_inline_template = {
    "mms": {
      "template": {
        "fields": {
          "subject": "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!",
          "fallback text": "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!",
          "slides": [
            {
              "content_length": "1234567"
            }
          ]
        }
      }
    }
  }

  describe Urbanairship::Devices::MmsNotification do

    describe '#mms_override' do
      it 'can format mms override correctly' do
        override = UA::MmsNotification.new(client: airship)
        override.fallback_text = "See https://urbanairship.com for double rainbows!"
        override.shorten_links = true
        override.content_length = 238686
        override.content_type = "image/jpeg"
        override.url = "https://www.metoffice.gov.uk/binaries/content/gallery/mohippo/images/learning/learn-about-the-weather/rainbows/full_featured_double_rainbow_at_savonlinna_1000px.jpg"
        override.text = "A double rainbow is a wonderful sight where you get two spectacular natural displays for the price of one."
        override.subject = "Double Rainbows"
        result = override.mms_override
        expect(result).to eq(mms_override_payload)
      end
    end

    describe '#mms_inline_template' do

      it 'can format inline template with template id correctly' do
        inline_template = UA::MmsNotification.new(client: airship)
        inline_template.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        result = inline_template.mms_inline_template
        expect(result).to eq(mms_template_with_id)
      end

      it 'can format mms inline template correctly' do
        inline_template = UA::MmsNotification.new(client: airship)
        inline_template.subject = "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!"
        inline_template.fallback_text = "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!"
        inline_template.content_length = "1234567"
        result = inline_template.mms_inline_template
        expect(result).to eq(mms_inline_template)
      end
    end

  end

end
