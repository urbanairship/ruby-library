require 'json'

require 'ext/object'
require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
  module Devices

    class ChannelUninstall
      attr_writer :client
      include Urbanairship::Common
      include Urbanairship::Loggable

      # Initialize a ChannelUninstall Object
      #
      # @param [Object] client
      def initialize(client)
        @client = client
      end

      def uninstall(channels)
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
