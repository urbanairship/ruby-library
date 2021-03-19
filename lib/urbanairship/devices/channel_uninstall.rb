require 'json'
require 'urbanairship'

module Urbanairship
  module Devices
    class ChannelUninstall
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_reader :client

      # Initialize a ChannelUninstall Object
      #
      # @param [Object] client
      def initialize(client: required('client'))
        @client = client
      end

      def uninstall(channels: required('channels'))
        chan_num = channels.length
        fail ArgumentError,
             'Maximum of 200 channel uninstalls exceeded.' if chan_num > 200

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(channels),
          path: channel_path('uninstall/'),
          content_type: 'application/json'
        )

        logger.info { "Successfully uninstalled #{chan_num} channels." }
        response
      end
    end


    class OpenChannelUninstall
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_reader :client

      def initialize(client: required('client'))
        @client = client
      end

      def uninstall(address: required('address'),
                    open_platform: required('open_platform'))

        body = {
          address: address,
          open_platform_name: open_platform
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(body),
          url: open_channel_url('uninstall/'),
          content_type: 'application/json'
        )

        logger.info { "Successfully uninstalled open channel with address: #{address}"}
        response
      end
    end
  end
end
