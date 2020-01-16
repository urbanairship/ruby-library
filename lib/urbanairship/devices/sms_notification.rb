require 'urbanairship'
require 'json'

module Urbanairship
  module Devices
    class SmsNotification
      include Urbanairship::Common
      include Urbanairship::Loggable

      attr_accessor :sms_alert,
                    :generic_alert,
                    :expiry,
                    :shorten_links,
                    :template_id

      def initialize(client: required('client'))
        @client = client
        @alert = nil
        @generic_alert = nil
        @expiry = nil
        @shorten_links = nil
        @template_id = nil
      end

      def sms_notification_override
        {
           "alert": @generic_alert,
           "sms": {
              "alert": @sms_alert,
              "expiry": @expiry,
              "shorten_links": @shorten_links
           }
        }
      end

      def sms_inline_template
        inline_template = {
          "sms": {
            "template": {}
          }
        }

        if @template_id
          inline_template[:sms][:template][:template_id] = @template_id
        end

        if @sms_alert
          inline_fields= {
            "fields": {"alert": @sms_alert}
          }
          inline_template[:sms][:template] = inline_fields
        end
        
        inline_template
      end

    end
  end
end
