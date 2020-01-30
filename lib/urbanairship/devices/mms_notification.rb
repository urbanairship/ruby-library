require 'urbanairship'
require 'json'

module Urbanairship
  module Devices
    class MmsNotification
      include Urbanairship::Common
      include Urbanairship::Loggable

      attr_accessor :fallback_text,
                    :shorten_links,
                    :content_length,
                    :content_type,
                    :url,
                    :text,
                    :subject,
                    :template_id,
                    :slide_1_text

      def initialize(client: required('client'))
        @client = client
        @fallback_text = nil
        @shorten_links = nil
        @content_length = nil
        @content_type = nil
        @url = nil
        @text = nil
        @subject = nil
        @template_id = nil
        @slide_1_text = nil
      end

      def mms_override
        fail ArgumentError, 'fallback_text is needed for MMS override' if @fallback_text.nil?
        fail ArgumentError, 'content_length is needed for MMS override' if @content_length.nil?
        fail ArgumentError, 'content_type is needed for MMS override' if @content_type.nil?
        fail ArgumentError, 'url is needed for MMS override' if @url.nil?

        override = {"mms": {
                "subject": @subject,
                "fallback_text": @fallback_text,
                "shorten_links": @shorten_links,
                "slides": [
                      {
                         "text": @text,
                         "media": {
                            "url": @url,
                            "content_type": @content_type,
                            "content_length": @content_length
                         }
                      }
                    ]
                 }
              }
        override
      end

      def mms_template_with_id
        fail ArgumentError, 'template_id is needed for MMS Inline Template with ID' if @template_id.nil?
        {"mms": {
            "template": {
              "template_id": @template_id
            }
          }
        }
      end

      def mms_inline_template
        template = {
          "mms": {
            "template": {
              "fields": {
                "subject": @subject,
                "fallback text": @fallback_text,
                "slide_1_text": @slide_1_text,
                "slides": [
                  {
                    "url": @url,
                    "content_type": @content_type,
                    "content_length": @content_length
                  }
                ]
              }
            }
          }
        }
      end

    end
  end
end
