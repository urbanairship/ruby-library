require 'uri'
require 'urbanairship'
require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
  module CustomEvents
    class CustomEvent
      include Urbanairship::Common
      include Urbanairship::Loggable

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
        cer = CustomEventResponse.new(body: response['body'], code: response['code'])
        logger.info { cer.format }

        cer
      end
    end

    # Response to a successful custom event creation.
    class CustomEventResponse
      attr_reader :ok, :operation_id, :payload, :status_code

      def initialize(body: nil, code: nil)
        @payload = (body.nil? || body.empty?) ? {} : body
        @ok = payload['ok']
        @operation_id = payload['operation_id']
        @status_code = code
      end

      # String Formatting of the CustomEventResponse
      #
      # @return [Object] String Formatted CustomEventResponse
      def format
        "Received [#{status_code}] response code.\nBody:\n#{formatted_body}"
      end

      def formatted_body
        payload
          .map { |key, value| "#{key}:\t#{value.to_s || 'None'}" }
          .join("\n")
      end
    end
  end
end
