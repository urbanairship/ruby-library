require 'urbanairship'
require 'urbanairship/devices/email_notification'

module Urbanairship
  module Devices
    class CreateAndSend
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :addresses,
                    :device_types,
                    :notification,
                    :campaigns

      def initialize(client: required('client'))
        @client = client
        @addresses = nil
        @device_types = nil
        @notification = nil
        @campaigns = nil
      end

      def validate_address
        @addresses.each do |address|
          fail ArgumentError, 'each address component must have a ua_address' if !address[:ua_address]
        end
        #need ua_address
        #need ua_commercial_opeted_in
        #need ua_transactional_opted_in
        #need need "substitutions"
      end

      def create_and_send
        fail ArgumentError, 'create and send object must be set for email channel' if @addresses.nil?
        fail ArgumentError, 'device type array must be set for email channel' if @device_types.nil?
        fail ArgumentError, 'notification object must be set for email channel' if @notification.nil?

        validate_address

        payload = {
          'audience': {
            'create_and_send': @addresses
          },
          'device_types': @device_type,
          'notification': @notification,
          'campaigns': {
              'categories': @campaigns
            }
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

      def validate
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
          url: CREATE_AND_SEND_URL + 'validate',
          content_type: 'application/json'
        )
        logger.info("Validating payload for create and send")
        # logger.info("Registering email channel with address #{@address}")
        response
      end

      def operation
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
          url: SCHEDULES_URL + 'create_and_send',
          content_type: 'application/json'
        )
        logger.info("Validating payload for create and send")
        # logger.info("Registering email channel with address #{@address}")
        response
      end

    end
  end
end
