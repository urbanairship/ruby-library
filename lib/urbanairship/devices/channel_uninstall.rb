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
          url: CHANNEL_URL + 'uninstall/',
          content_type: 'application/json',
          version: 3
        )

        logger.info { "Successfully uninstalled #{chan_num} channels." }
        response
      end
    end
  end
end
