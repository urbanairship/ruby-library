require 'uri'
require 'urbanairship'
require 'urbanairship/common'

module Urbanairship
  module CustomEvents
    class CustomEvent
      include Urbanairship::Common

      attr_accessor :events

      def initialize(client: required('client'))
        @client = client
      end

      def create
        fail ArgumentError, 'events must be an array of custom events' unless events.is_a?(Array)

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(events),
          url: custom_events_url,
          content_type: 'application/json'
        )
        response
      end
    end
  end
end
