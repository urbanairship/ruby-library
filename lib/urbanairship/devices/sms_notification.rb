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
                    :shorten_links

      def initialize(client: required('client'))
        @client = client
        @alert = nil
        @generic_alert = nil
        @expiry = nil
        @shorten_links = nil
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

    end
  end
end
