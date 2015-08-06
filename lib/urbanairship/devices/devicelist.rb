require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelInfo
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_writer :client

      def initialize(client)
        @client = client
      end

      def lookup(uuid: required)
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid
        )
        logger.info("Retrieved channel information for #{uuid}")
        response['body']['channel']
      end
    end

    class ChannelList < Urbanairship::Common::PageIterator
      def initialize(client)
        super(client)
        @next_page = CHANNEL_URL
        @data_attribute = 'channels'
        load_page
      end
    end

    class Feedback
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client)
        @client = client
      end

      def device_token(since: required)
        url = DT_FEEDBACK_URL + '?since=' + since
        get_feedback(url: url)
      end

      def apid(since: required)
        url = APID_FEEDBACK_URL + '?since=' + since
        get_feedback(url: url)
      end

      def get_feedback(url: required)
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