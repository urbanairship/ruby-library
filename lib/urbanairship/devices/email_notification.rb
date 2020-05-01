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
                    :variable_details,
                    :click_tracking,
                    :open_tracking

      def initialize(client: required('client'))
        @client = client
      end

      def email_override
        fail ArgumentError, 'message_type is needed for email override' if @message_type.nil?
        fail ArgumentError, 'plaintext_body is needed for email override' if @plaintext_body.nil?
        fail ArgumentError, 'reply_to is needed for email override' if @reply_to.nil?
        fail ArgumentError, 'sender_address is needed for email override' if @sender_address.nil?
        fail ArgumentError, 'sender_name is needed for email override' if @sender_name.nil?
        fail ArgumentError, 'subject is needed for email override' if @subject.nil?

        override = {
          bcc: bcc,
          bypass_opt_in_level: bypass_opt_in_level,
          click_tracking: click_tracking,
          html_body: html_body,
          message_type: message_type,
          open_tracking: open_tracking, 
          plaintext_body: plaintext_body,
          reply_to: reply_to,
          sender_address: sender_address,
          sender_name: sender_name,
          subject: subject
        }.compact #.compact removes the nil key value pairs

        {'email': override}
      end

      def email_with_inline_template
        fail ArgumentError, 'message_type is needed for email with inline template' if @message_type.nil?
        fail ArgumentError, 'reply_to is needed for email with inline template' if @reply_to.nil?
        fail ArgumentError, 'sender_address is needed for email with inline template' if @sender_address.nil?
        fail ArgumentError, 'sender_name is needed for email with inline template' if @sender_name.nil?

        inline_template = {'email': {
          'message_type': @message_type,
          'reply_to': @reply_to,
          'sender_address': @sender_address,
          'sender_name': @sender_name,
          'template': {}
          }
        }

        if @subject and @plaintext_body
          fields_object = {'plaintext_body': @plaintext_body, 'subject': @subject}
          inline_template[:email][:template][:fields] = fields_object
        end

        if @bcc
          inline_template[:email][:bcc] = @bcc
        end

        if @variable_details
          inline_template[:email][:template][:variable_details] = @variable_details
        end

        if @template_id
          inline_template[:email][:template][:template_id] = @template_id
        end

        inline_template
      end

    end
  end
end
