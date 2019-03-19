require 'urbanairship'

module Urbanairship
  module  Devices
    class Email
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :type, :commercial_opted_in, :address, :timezone, :locale_country, :locale_language

      def initialize(client: required('client'))
        @client = client
        @type = nil
        @commercial_opted_in = nil
        @address = nil
        @timezone = nil
        @locale_country = nil
        @locale_language = nil
      end

      def register
        fail ArgumentError, 'address must be set to register email channel' if @address.nil?

        payload = {
          'channel': {
            'type': @type,
            'commercial_opted_in': @commercial_opted_in,
            'address': @address,
            'timezone': @timezone,
            'locale_country': @locale_country,
            'locale_language': @locale_language
          }
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CHANNEL_URL + 'email',
          content_type: 'application.json'
        )
        logger.info("Registering email channel with address #{@address}")
        response
      end

    end
  end
end
