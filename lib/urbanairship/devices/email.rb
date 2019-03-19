require 'urbanairship'

module Urbanairship
  module  Devices
    class Email
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :address,
                    :commercial_opted_in,
                    :commercial_opted_out,
                    :locale_country,
                    :locale_language,
                    :timezone,
                    :transactional_opted_in,
                    :transactional_opted_out,
                    :type,

      def initialize(client: required('client'))
        @client = client
        @address = nil
        @commercial_opted_in = nil
        @commercial_opted_out = nil
        @locale_country = nil
        @locale_language = nil
        @timezone = nil
        @transactional_opted_in = nil
        @transactional_opted_out = nil
        @type = nil
      end

      def register
        fail ArgumentError, 'address must be set to register email channel' if @address.nil?

        payload = {
          'channel': {
            'address': @address,
            'commercial_opted_in': @commercial_opted_in,
            'commercial_opted_out': @commercial_opted_out,
            'locale_country': @locale_country,
            'locale_language': @locale_language,
            'timezone': @timezone,
            'transactional_opted_in': @transactional_opted_in,
            'transactional_opted_out': @transactional_opted_out,
            'type': @type
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
