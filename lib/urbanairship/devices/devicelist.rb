require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelInfo
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_writer :client

      def initialize(client: client)
        @client = client
      end

      def lookup(uuid: required)
        response = @client.send_request(
          method: 'GET',
          url: CHANNEL_URL + uuid,
          version: 3
        )
        logger.info("Retrieved channel information for #{uuid}")
        response['body']['channel']
      end
    end

    class ChannelList
      include Urbanairship::Common
      include Urbanairship::Loggable
      include Enumerable

      def initialize(client: client)
        @next_page = CHANNEL_URL
        @client = client
        @channel_list = nil
        load_page
      end

      def each
        while @channel_list
          @channel_list.each do | value |
            yield value
          end
          @channel_list = nil
          if @next_page
            load_page
          end
        end
      end

      def load_page
        response = @client.send_request(
          method: 'GET',
          url: @next_page,
          version: 3
        )
        logger.info("Retrieved channel list from #{@next_page}")
        if response['body']['next_page']
          @next_page = response['body']['next_page']
        else
          @next_page = nil
        end
        @channel_list = response['body']['channels']
      end
    end
  end
end