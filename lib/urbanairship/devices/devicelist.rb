require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelInfo
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_writer :client
      attr_accessor :audience,
                    :attributes

      def initialize(client: required('client'))
        @client = client
      end

      def lookup(uuid: required('uuid'))
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid
        )
        logger.info("Retrieved channel information for #{uuid}")
        response['body']['channel']
      end

      def set_attributes
        payload = {
          'audience': {
            audience
          },
          'attributes': [
            attributes
          ]
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: CHANNEL_URL + 'attributes',
          content_type: 'application/json'
        )
        logger.info("Setting attributes for channel(s) #{audience}")
        response
      end
    end

    class ChannelList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = CHANNEL_URL
        @data_attribute = 'channels'
      end
    end

    class DeviceToken
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def lookup(token: required('token'))
        fail ArgumentError, 'token needs to be a string' unless token.is_a? String

        resp = @client.send_request(
          method: 'GET',
          url: DEVICE_TOKEN_URL + token
        )
        logger.info("Looking up info on device token #{token}")
        resp
      end
    end

    class DeviceTokenList < Urbanairship::Common::PageIterator
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        super(client: client)
        @next_page = DEVICE_TOKEN_URL
        @data_attribute = 'device_tokens'
      end
    end

    class APID
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def lookup(apid: required('apid'))
        fail ArgumentError, 'apid needs to be a string' unless apid.is_a? String

        resp = @client.send_request(
          method: 'GET',
          url: APID_URL + apid
        )
        logger.info("Retrieved info on apid #{apid}")
        resp
      end
    end

    class APIDList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = APID_URL
        @data_attribute = 'apids'
      end
    end
  end
end