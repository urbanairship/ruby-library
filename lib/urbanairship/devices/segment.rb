require 'json'

require 'ext/object'
require 'urbanairship/common'
require 'urbanairship/loggable'

module Urbanairship
  module Devices
    class Segment
      attr_accessor :display_name, :criteria
      attr_reader :creation_date, :modification_date, :url,
                  :id, :data
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

        seg_url = response.headers['location']
        @id = seg_url.split('/')[-1]
        response['code']
      end

      # Retrieve a segment based on the provided ID.
      def from_id(airship, id)
        url = SEGMENTS_URL + id
        response = airship.send_request(
          method='GET',
          body=nil,
          url=url,
          version=3
        )

        payload = response.body
        @id = id
        from_payload(payload)

        response
      end

      def from_payload(payload)
        payload.each do |key, val|
          # somethin
        end
      end

      def update
      end

      def delete
      end
    end

    class SegmentList
    end
  end
end
