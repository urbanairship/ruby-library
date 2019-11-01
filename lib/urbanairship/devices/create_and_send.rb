require 'urbanairship'
require 'pry'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :addresses,
                    :ua_address,
                    :ua_commercial_opeted_in,
                    :ua_transactional_opted_in,
                    :device_types,
                    :notification,
                    :campaigns,
                    :email

      def initialize(client: required('client'))
        @client = client
        @addresses = nil
        @ua_address = nil
        @ua_commercial_opeted_in = nil
        @ua_transactional_opted_in = nil
        @device_types = nil
        @notification = nil
        @campaigns = nil
        @email = nil
      end

      def create_and_send
        @addresses.each do |address|
          fail ArgumentError, 'each create_and_send object must have a ua_address' if !address[:ua_address]
        end
        #need ua_address
        #need ua_commercial_opeted_in
        #need ua_transactional_opted_in
        #need need "substitutions"
      end

      def email_channel
        fail ArgumentError, 'create and send object must be set for email channel' if @addresses.nil?
        fail ArgumentError, 'device type array must be set for email channel' if @device_types.nil?
        fail ArgumentError, 'notification object must be set for email channel' if @notification.nil?

        create_and_send

        payload = {
          'audience': {
            'create_and_send': @addresses
          },
          'device_types': @device_type,
          'notification': @notification,
          'campaigns': @campaigns
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CREATE_AND_SEND_URL,
          content_type: 'application/json'
        )
        logger.info("Doing create and send for email channel")
        # logger.info("Registering email channel with address #{@address}")
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

    end
  end
end
