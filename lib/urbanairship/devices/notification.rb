require 'urbanairship'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :bcc,
                    :bypass_opt_in_level,
                    :html_body,
                    :message_type,
                    :plaintext_body,
                    :reply_to,
                    :sender_address,
                    :sender_name,
                    :subject

      def initialize(client: required('client'))
        @client = client
        @bcc = nil
        @bypass_opt_in_level = nil
        @html_body = nil
        @message_type = nil
        @plaintext_body = nil
        @reply_to = nil
        @sender_address = nil
        @sender_name = nil
        @subject = nil
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
