require 'json'

require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
  module Devices
    class Segment
      attr_accessor :display_name, :criteria
      attr_reader :creation_date, :modification_date, :url,
                  :id
      include Urbanairship::Common
      include Urbanairship::Loggable

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

      # Retrieve a segment based on the provided ID.
      def from_id(airship, id)
        url = SEGMENTS_URL + id
        response = airship.send_request(
          method: 'GET',
          body: nil,
          url: url,
          content_type: 'application/json',
          version: 3
        )

        @id = id
        from_payload(self, response['body'])
        response
      end

      # helper method, sets a Segment object's display_name and criteria
      # attributes
      def from_payload(obj, payload)
        payload.each do |key, val|
          obj.instance_variable_set("@#{key}", val)
        end
      end


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
        response['code']
      end
    end

    # TODO
    class SegmentList
      attr_accessor :limit, :client
      attr_reader :start_url, :next_url, :data
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client, limit: nil)
        @client = client
        @start_url = SEGMENTS_URL
        @next_url = @start_url
        if limit != nil
          @limit = limit
        end
      end

    end
  end
end
