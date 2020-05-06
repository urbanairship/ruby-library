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
                    :campaigns,
                    :name,
                    :scheduled_time

      def initialize(client: required('client'))
        @client = client
      end

      def validate_address
        @addresses.each do |address|
          unless address.include?(:ua_address) or address.include?(:ua_msisdn && :ua_opted_in && :ua_sender)
            fail ArgumentError, 'Missing a component in address portion of the object'
          end
        end
      end

      def payload
        fail ArgumentError, 'addresses must be set for defining payload' if @addresses.nil?
        fail ArgumentError, 'device type array must be set for defining payload' if @device_types.nil?
        fail ArgumentError, 'notification object must be set for defining payload' if @notification.nil?

        validate_address

        full_payload = {
          'audience': {
            'create_and_send': addresses
          },
          'device_types': device_types,
          'notification': notification,
        }

        if campaigns
          campaign_object = {'categories': campaigns}
          full_payload[:campaigns] = campaign_object
        end
        
        full_payload
      end

      def create_and_send
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CREATE_AND_SEND_URL,
          content_type: 'application/json'
        )
        logger.info("Running create and send for addresses #{@addresses}")
        response
      end

      def validate
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CREATE_AND_SEND_URL + 'validate',
          content_type: 'application/json'
        )
        logger.info("Validating payload for create and send")
        response
      end

      def schedule
        fail ArgumentError, 'scheduled time must be set to run an operation' if @scheduled_time.nil?

        scheduled_payload = {
          "schedule": {
            "scheduled_time": scheduled_time
          },
          "name": name,
          "push": payload
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(scheduled_payload),
          url: SCHEDULES_URL + 'create-and-send',
          content_type: 'application/json'
        )
        logger.info("Scheduling create and send operation with name #{@name}")
        response
      end

    end
  end
end
