require 'spec_helper'
require 'urbanairship'
require 'urbanairship/devices/mms_notification'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  mms_override_payload = {
  "mms": {
    "fallback_text": "See https://urbanairship.com for double rainbows!",
    "shorten_links": true,
    "subject": "Double Rainbows",
    "slides": [
      {
        "text": "A double rainbow is a wonderful sight where you get two spectacular natural displays for the price of one.",
        "media": {
            "url": "https://www.metoffice.gov.uk/binaries/content/gallery/mohippo/images/learning/learn-about-the-weather/rainbows/full_featured_double_rainbow_at_savonlinna_1000px.jpg",
            "content_type": "image/jpeg",
            "content_length": 238686
          }
        }
      ]
    }
  }

  mms_template_with_id = {"mms": {
      "template": {
        "template_id": "9335bb2a-2a45-456c-8b53-42af7898236a"
      },
      "shorten_links": true,
      "slides": [
          {
              "media": {
                  "url": "https://www.metoffice.gov.uk/binaries/content/gallery/mohippo/images/learning/learn-about-the-weather/rainbows/full_featured_double_rainbow_at_savonlinna_1000px.jpg",
                  "content_type": "image/jpeg",
                  "content_length": 238686
              }
          }
      ]
    }
  }

  mms_inline_template = {"mms": {
    "template": {
      "fields": {
        "subject": "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!",
        "fallback_text": "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!",
        "slide_1_text": "text"
      }
    },
    "slides": [
      {
        "media": {
            "url": "www.google.com",
            "content_type": "image/jpeg",
            "content_length": 238686
        }
      }
    ]
  }
}

  describe Urbanairship::Devices::MmsNotification do

    describe '#validate_url' do
      it 'validates url ending in .jpg' do
        override = UA::MmsNotification.new(client: airship)
        override.url = "https://good-image.jpg"
        expect { override.validate_url }.not_to raise_error(ArgumentError)
      end

      it 'validates url ending in .gif' do
        override = UA::MmsNotification.new(client: airship)
        override.url = "https://good-image.gif"
        expect { override.validate_url }.not_to raise_error(ArgumentError)
      end

      it 'validates url ending in .png' do
        override = UA::MmsNotification.new(client: airship)
        override.url = "https://good-image.png"
        expect { override.validate_url }.not_to raise_error(ArgumentError)
      end

      it 'validates url ending in .jpeg' do
        override = UA::MmsNotification.new(client: airship)
        override.url = "https://good-image.jpeg"
        expect { override.validate_url }.not_to raise_error(ArgumentError)
      end
    end

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

    describe '#mms_template_with_id' do
      it 'can format inline template with template id correctly' do
        inline_template = UA::MmsNotification.new(client: airship)
        inline_template.url = "https://www.metoffice.gov.uk/binaries/content/gallery/mohippo/images/learning/learn-about-the-weather/rainbows/full_featured_double_rainbow_at_savonlinna_1000px.jpg"
        inline_template.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
        inline_template.content_length = 238686
        inline_template.content_type = "image/jpeg"
        result = inline_template.mms_template_with_id
        expect(result).to eq(mms_template_with_id)
      end
    end


    describe '#mms_inline_template' do
      it 'can format mms inline template correctly' do
        inline_template = UA::MmsNotification.new(client: airship)
        inline_template.subject = "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!"
        inline_template.fallback_text = "Hi, {{customer.first_name}}, your {{#each order}}{{order.name}}{{/each}} was delivered!"
        inline_template.text = "text"
        inline_template.content_length = 238686
        inline_template.content_type = "image/jpeg"
        inline_template.url = "www.google.com"
        result = inline_template.mms_inline_template
        expect(result).to eq(mms_inline_template)
      end
    end

  end

end
