require 'urbanairship'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :create_and_send,
                    :ua_address,
                    :ua_commercial_opeted_in,
                    :ua_transactional_opted_in,
                    :device_types,
                    :notification,
                    :campaigns,
                    :email

      def initialize(client: required('client'))
        @client = client
        @create_and_send = nil
        @ua_address = nil
        @ua_commercial_opeted_in = nil
        @ua_transactional_opted_in = nil
        @device_types = nil
        @notification = nil
        @campaigns = nil
        @email = nil
      end

      def create_and_send()
        #need ua_address
        #need ua_commercial_opeted_in
        #need ua_transactional_opted_in
        #need need "substitutions"
      end

      def email_channel
        fail ArgumentError, 'address must be set to register email channel' if @create_and_send.nil?
        fail ArgumentError, 'address must be set to register email channel' if @device_types.nil?
        fail ArgumentError, 'address must be set to register email channel' if @notification.nil?

        payload = {
          'audience': {
            'create_and_send': @audience
          },
          'device_types': @device_type,
          'notification': @notification,
          'campaigns': @campaigns
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CREATE_AND_SEND_URL
          content_type: 'application/json'
        )
        logger.info("Registering email channel with address #{@address}")
        response
      end

      def sms_channel

      end

      def mms_notification

      end

      def open_channels

      end

      def validate

      end

      def operation

      end
