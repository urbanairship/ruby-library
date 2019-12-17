require 'urbanairship'
require 'json'

module Urbanairship
  module Devices
    class EmailNotification
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
                    :subject,
                    :template_id,
                    :variable_details

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
        @template_id = nil
        @variable_details = nil
      end

      def email_override
        fail ArgumentError, 'message_type is needed for email override' if @message_type.nil?
        fail ArgumentError, 'plaintext_body is needed for email override' if @plaintext_body.nil?
        fail ArgumentError, 'reply_to is needed for email override' if @reply_to.nil?
        fail ArgumentError, 'sender_address is needed for email override' if @sender_address.nil?
        fail ArgumentError, 'sender_name is needed for email override' if @sender_name.nil?
        fail ArgumentError, 'subject is needed for email override' if @subject.nil?

        override = {'email': {
          'bcc': @bcc,
          'bypass_opt_in_level': @bypass_opt_in_level,
          'html_body': @html_body,
          'message_type': @message_type,
          'plaintext_body': @plaintext_body,
          'reply-to': @reply_to,
          'sender_address': @sender_address,
          'sender_name': @sender_name,
          'subject': @subject
        }}
        override
      end

      def email_with_inline_template
        fail ArgumentError, 'message_type is needed for email with inline template' if @message_type.nil?
        fail ArgumentError, 'reply_to is needed for email with inline template' if @reply_to.nil?
        fail ArgumentError, 'sender_address is needed for email with inline template' if @sender_address.nil?
        fail ArgumentError, 'sender_name is needed for email with inline template' if @sender_name.nil?
        fail ArgumentError, 'template_id is needed for email with inline template' if @template_id.nil?
        fail ArgumentError, 'plaintext_body is needed for email with inline template' if @plaintext_body.nil?
        fail ArgumentError, 'subject is needed for email with inline template' if @subject.nil?

        inline_template = {'email': {
          'bcc': @bcc,
          'message_type': @message_type,
          'reply-to': @reply_to,
          'sender_address': @sender_address,
          'sender_name': @sender_name,
          'template': {
            'template_id': @template_id,
            "fields": {
              'plaintext_body': @plaintext_body,
              'subject': @subject
            },
            'variable_details': @variable_details
            }
          }
        }
        inline_template
      end

    end
  end
end
