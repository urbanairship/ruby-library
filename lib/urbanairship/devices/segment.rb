require 'json'

require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
  module Devices
    class Segment
      attr_accessor :display_name, :criteria, :creation_date,
                    :modification_date, :url, :id
      include Urbanairship::Common
      include Urbanairship::Loggable

      # Build a Segment from the display_name and criteria attributes
      #
      # @param [Object] client The Client
      # @return [Object] response HTTP response
      def create(airship)
        payload = {
          display_name: @display_name,
          criteria: @criteria
        }
        response = airship.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: SEGMENTS_URL,
          content_type: 'application/json',
          version: 3
        )
        logger.info { "Successful segment creation: #{@display_name}" }

        seg_url = response['headers'][:location]
        @id = seg_url.split('/')[-1]
        response
      end

      # Build a Segment from the display_name and criteria attributes
      #
      # @param [Object] airship The Client
      # @param [Object] id The id of the segment being looked up
      def from_id(airship, id)
        url = SEGMENTS_URL + id
        response = airship.send_request(
          method: 'GET',
          body: nil,
          url: url,
          content_type: 'application/json',
          version: 3
        )

        payload = response['body']
        @id = id
        from_payload(payload)
      end

      # Helper method, sets a Segment's attributes
      #
      # @ param [Object] payload A Hash of segment attributes and their values
      def from_payload(payload)
        payload.each { |key, val| send("#{key}=", val) }
      end

      # Update a segment with new criteria/display_name
      #
      # @ param [Object] airship The client
      # @ returns [Object] response HTTP response
      def update(airship)
        data = {}
        data[:display_name] = @display_name
        data[:criteria] = @criteria

        url = SEGMENTS_URL + @id
        response = airship.send_request(
          method: 'PUT',
          body: JSON.dump(data),
          url: url,
          content_type: 'application/json',
          version: 3
        )

        logger.info { "Successful segment update: #{@display_name}" }
        response
      end

      # Delete a segment
      #
      # @ param [Object] airship The client
      # @ returns [Object] response HTTP response
      def delete(airship)
        url = SEGMENTS_URL + @id
        response = airship.send_request(
          method: 'DELETE',
          body: nil,
          url: url,
          content_type: 'application/json',
          version: 3
        )

        logger.info { "Successful segment deletion: #{@display_name}" }
        response
      end
    end

    class SegmentList
      attr_accessor :limit, :client
      attr_reader :start_url, :next_url, :data
      include Urbanairship::Common
      include Urbanairship::Devices
      include Enumerable

      def initialize(client, limit: nil)
        @client = client
        @start_url = SEGMENTS_URL
        @next_url = @start_url
        @data = []
        if limit != nil
          @limit = limit
        end
      end

      # Makes the SegmentList iterable
      #
      # @ param [Object] block A ruby block with instructions on processing
      #     each element of the iterable.
      def each(&block)
        # Continue to load more data so long as [next_url] is not nil.
        while @next_url
          get_page
          @data.each(&block)
        end
      end

      # Get a page of results
      def get_page
        if @limit != nil
          params = {'limit' => @limit}
        else
          params = nil
        end

        response = @client.send_request(
          method: 'GET',
          body: nil,
          url: @next_url,
          content_type: 'application/json',
          params: params,
          version: 3
        )

        @data = response['body']['segments'].map do |raw|
          s = UA::Segment.new
          s.from_payload(raw); s
        end
        @next_url = response['body']['next_page']
      end

    end
  end
end
