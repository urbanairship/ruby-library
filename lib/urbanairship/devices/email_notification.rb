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
        @click_tracking = nil
        @open_tracking  = nil
      end

      def email_override
        fail ArgumentError, 'message_type is needed for email override' if @message_type.nil?
        fail ArgumentError, 'plaintext_body is needed for email override' if @plaintext_body.nil?
        fail ArgumentError, 'reply_to is needed for email override' if @reply_to.nil?
        fail ArgumentError, 'sender_address is needed for email override' if @sender_address.nil?
        fail ArgumentError, 'sender_name is needed for email override' if @sender_name.nil?
        fail ArgumentError, 'subject is needed for email override' if @subject.nil?

        override = {'email': {
          'message_type': @message_type,
          'plaintext_body': @plaintext_body,
          'reply_to': @reply_to,
          'sender_address': @sender_address,
          'sender_name': @sender_name,
          'subject': @subject
        }}

        if @bcc
          override[:email][:bcc] = @bcc
        end

        if @bypass_opt_in_level
          override[:email][:bypass_opt_in_level] = @bypass_opt_in_level
        end

        if @html_body
          override[:email][:html_body] = @html_body
        end

        if @open_tracking
          override[:email][:open_tracking] = @open_tracking
        end

        override
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
