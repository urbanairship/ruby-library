require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelInfo
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_writer :client

      def initialize(client: required('client'))
        @client = client
      end

      def lookup(uuid: required('uuid'))
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid,
          version: 3
        )
        logger.info("Retrieved channel information for #{uuid}")
        response['body']['channel']
      end
    end

    class ChannelList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = CHANNEL_URL
        @data_attribute = 'channels'
        load_page
      end
    end

    class Feedback
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def device_token(since: required('device token'))
        url = DT_FEEDBACK_URL + '?since=' + since
        get_feedback(url: url)
      end

      def apid(since: required('since'))
        url = APID_FEEDBACK_URL + '?since=' + since
        get_feedback(url: url)
      end

      def get_feedback(url: required('url'))
        response = @client.send_request(
            method: 'GET',
            url: url,
            version: 3
        )
        logger.info("Requested feedback at url #{url}")
        response
      end
    end
  end
end