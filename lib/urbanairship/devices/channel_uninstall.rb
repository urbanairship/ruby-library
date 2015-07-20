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

      def initialize(client)
        @client = client
      end

      def uninstall(channels)
        fail ArgumentError,
             'Maximum of 200 channel uninstalls exceeded.' if channels.length > 200

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(channels),
          url: CHANNEL_URL + 'uninstall/',
          content_type: 'application/json',
          version: 3
        )

        response
      end

    end
  end
end
