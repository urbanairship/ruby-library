require 'json'
require 'urbanairship/common'
require 'urbanairship/loggable'


module Urbanairship
  module Push

    # A Push Notification.
    class Push
      attr_writer :client, :audience, :notification, :options,
                  :device_types, :message
      attr_reader :device_types, :audience
      include Urbanairship::Common
      include Urbanairship::Loggable

      # Initialize a Push Object
      #
      # @param [Object] client
      def initialize(client)
        @client = client
      end

      def payload
        compact_helper({
          audience: @audience,
          notification: @notification,
          options: @options,
          device_types: @device_types,
          message: @message
        })
      end

      # Send the Push Object
      #
      # @raise [AirshipFailure] if the request failed
      # @raise [Unauthorized] if authentication failed
      # @raise [Forbidden] if app does not have entitlement
      # @return [PushResponse] with `push_ids` and other response data.
      def send_push
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: PUSH_URL,
          content_type: 'application/json'
        )
        pr = PushResponse.new(http_response_body: response['body'], http_response_code: response['code'].to_s)
        logger.info { pr.format }
        pr
      end
    end


    class ScheduledPush
      attr_writer :schedule, :name, :push, :url
      attr_reader :url, :push
      include Urbanairship::Common
      include Urbanairship::Loggable

      # Initialize a Scheduled Push Object
      #
      # @param [Object] client
      def initialize(client)
        @client = client
      end

      def payload
        compact_helper({
          name: @name,
          schedule: @schedule,
          push: @push.payload
        })
      end

      # Schedule the Push Notification
      #
      # @raise [AirshipFailure] if the request failed
      # @raise [Unauthorized] if authentication failed
      # @raise [Forbidden] if app does not have entitlement
      # @return [PushResponse] with `schedule_url` and other response data.
      def send_push
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: SCHEDULES_URL,
          content_type: 'application/json'
        )
        pr = PushResponse.new(http_response_body: response['body'], http_response_code: response['code'].to_s)
        logger.info { pr.format }
        @url = pr.schedule_url
        pr
      end

      # Build a Scheduled Push Notification object its existing Scheduled Push URL
      #
      # @param [Object] client The Client
      # @param [Object] url The existing Scheduled Push URL
      # @return [Object] Scheduled Push Object
      def self.from_url(client: required('client'), url: required('url'))
        scheduled_push = ScheduledPush.new(client)
        response_body = client.send_request(
          method: 'GET',
          body: nil,
          url: url
        )
        payload = JSON.load(response_body)

        p = Push.new(client)
        p.audience = payload['push']['audience']
        p.notification = payload['push']['notification']
        p.device_types = payload['push']['device_types']
        p.message = payload['push']['message']
        p.options = payload['push']['options']

        scheduled_push.name = payload['name']
        scheduled_push.schedule = payload['schedule']
        scheduled_push.push = p
        scheduled_push.url = url
        scheduled_push
      end

      # Cancel the Scheduled Push
      #
      # @return [Object] Push Response
      def cancel
        fail ArgumentError,
           'Cannot cancel ScheduledPush without a url.' if @url.nil?

        response = @client.send_request(
          method: 'DELETE',
          body: nil,
          url: @url,
          content_type: 'application/json'
        )
        pr = PushResponse.new(http_response_body: response['body'], http_response_code: response['code'].to_s)
        logger.info { "Result of canceling scheduled push: #{@url} was a: [#{pr.status_code}]" }
        pr
      end

      # Update the Scheduled Push
      #
      # @return [Object]
      def update
        fail ArgumentError,
           'Cannot update a ScheduledPush without a url.' if @url.nil?
        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(self.payload),
          url: @url,
          content_type: 'application/json'
        )
        pr = PushResponse.new(http_response_body: response['body'], http_response_code: response['code'].to_s)
        logger.info { pr.format }
        pr
      end

      def list(schedule_id: required('schedule_id'))
        fail ArgumentError,
           'schedule_id must be a string' unless schedule_id.is_a? String
        resp = @client.send_request(
          method: 'GET',
          url: SCHEDULES_URL + schedule_id
        )
        logger.info("Retrieved info for schedule_id #{schedule_id}")
        resp
      end
    end


    class ScheduledPushList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = SCHEDULES_URL
        @data_attribute = 'schedules'
      end
    end

    # Response to a successful push notification send or schedule.
    class PushResponse
      attr_reader :ok, :push_ids, :schedule_url, :operation_id, :payload, :status_code
      include Urbanairship::Common

      def initialize(http_response_body: nil, http_response_code: nil)
        @payload = ((http_response_body.nil? || http_response_body.empty?) ? {} : http_response_body)
        @ok = @payload['ok']
        @push_ids = @payload['push_ids']
        @schedule_url = try_helper(:first, @payload['schedule_urls'])
        @operation_id = @payload['operation_id']
        @status_code = http_response_code
      end

      # String Formatting of the PushResponse
      #
      # @return [Object] String Formatted PushResponse
      def format
        base = "Received [#{@status_code}] response code. \nHeaders: \tBody:\n"
        payload.each do |key, value|
          safe_value = value.to_s || 'None'
          base << "#{key}:\t#{safe_value}\n"
        end
        base
      end
    end
  end
end
