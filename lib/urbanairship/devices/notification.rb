require 'urbanairship'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :

      def initialize(client: required('client'))
        @client = client
      end

      def email_override
      end

      def email_with_inline_template

      end

      def mms_platform_override
      end

      def mms_with_inline_template
      end

      def open_channel_override
      end

      def sms_platform_override
      end

      def sms_with_inline_template
      end

    end
  end
end
