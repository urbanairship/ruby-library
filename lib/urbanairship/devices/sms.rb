require 'urbanairship'

module Urbanairship
  module Devices
    class Sms
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :msisdn,
                    :sender,
                    :opted_in,
                    :sender,
                    :locale_country,
                    :locale_language,
                    :timezone,
                    :channel_id

      def initialize(client: required('client'))
        @client = client
      end

      def register
        fail ArgumentError, 'sender must be set to register sms channel' if sender.nil?
        fail ArgumentError, 'msisdn must be set to register sms channel' if msisdn.nil?

        payload = {
          'msisdn': msisdn,
          'sender': sender,
          'opted_in': opted_in
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: channel_path('sms'),
          content_type: 'application/json'
        )
        logger.info("Registering SMS channel with msisdn #{@msisdn}")
        response
      end

      def update
        fail ArgumentError, 'sender must be set to update sms channel' if sender.nil?
        fail ArgumentError, 'msisdn must be set to update sms channel' if msisdn.nil?
        fail ArgumentError, 'channel_id must be set to update sms channel' if channel_id.nil?

        payload = {
          'msisdn': msisdn,
          'sender': sender,
          'opted_in': opted_in,
          'locale_country': locale_country,
          'locale_language': locale_language,
          'timezone': timezone
        }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs

        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(payload),
          path: channel_path('sms/' + channel_id),
          content_type: 'application/json'
        )
        logger.info("Updating SMS channel with msisdn #{@channel_id}")
        response
      end

      def opt_out
        fail ArgumentError, 'sender must be set to opt out sms channel' if sender.nil?
        fail ArgumentError, 'msisdn must be set to opt out sms channel' if msisdn.nil?

        payload = {
          'msisdn': msisdn,
          'sender': sender,
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: channel_path('sms/opt-out'),
          content_type: 'application/json'
        )
        logger.info("Opting Out of SMS messages for #{@msisdn}")
        response
      end

      def uninstall
        fail ArgumentError, 'sender must be set to uninstall sms channel' if sender.nil?
        fail ArgumentError, 'msisdn must be set to uninstall sms channel' if msisdn.nil?

        payload = {
          'msisdn': msisdn,
          'sender': sender,
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: channel_path('sms/uninstall'),
          content_type: 'application/json'
        )
        logger.info("Uninstalling SMS channel for #{@msisdn}")
        response
      end

      def lookup
        fail ArgumentError,'msisdn is required for lookup' if msisdn.nil?
        fail ArgumentError,'sender is required for lookup' if sender.nil?

        response = @client.send_request(
            method: 'GET',
            path: channel_path('sms/' + @msisdn + '/' + @sender)
        )
        logger.info { "Retrieved information for msisdn #{@msisdn}" }
        response
      end
    end
  end
end
