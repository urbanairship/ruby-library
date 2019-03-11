require 'urbanairship'

module Urbanairship
  module Devices
    class Sms
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :msisdn, :sender, :opted_in, :sender

      def initialize(client: required('client'))
        @client = client
        @sender = nil
        @msisdn = nil
        @opted_in = nil
      end

      def register()
        fail ArgumentError, 'sender must be set to register sms channel' if @sender.nil?
        fail ArgumentError, 'msisdn must be set to register sms channel' if @msisdn.nil?

        payload = {
          'msisdn': @msisdn,
          'sender': @sender,
          'opted_in': @opted_in
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CHANNEL_URL + '/sms',
          content_type: 'application/json'
        )
        logger.info("Registering SMS channel with msisdn #{@msisdn}")
        response
      end

      def opt_out()
        fail ArgumentError, 'sender must be set to register sms channel' if @sender.nil?
        fail ArgumentError, 'msisdn must be set to register sms channel' if @msisdn.nil?

        payload = {
          'msisdn': @msisdn,
          'sender': @sender,
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CHANNEL_URL + '/sms/opt-out',
          content_type: 'application/json'
        )
        logger.info("Opting Out of SMS messages for #{@msisdn}")
      end
    end
  end
end
