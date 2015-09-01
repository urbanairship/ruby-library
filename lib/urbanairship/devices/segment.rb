require 'json'
require 'urbanairship'


module Urbanairship
  module Devices
    class Segment
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :display_name, :criteria

      def initialize(client: required('client'))
        @client = client
        @display_name = nil
        @criteria = nil
        @id = nil
      end

      # Build a Segment from the display_name and criteria attributes
      #
      # @param [Object] client The Client
      # @return [Object] response HTTP response
      def create
        fail ArgumentError,
          'Both display_name and criteria must be set to a value' if display_name.nil? or criteria.nil?
        payload = {
          :display_name => @display_name,
          :criteria => @criteria
        }
        response = @client.send_request(
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
      # @param [Object] id The id of the segment being looked up
      def from_id(id: required('id'))
        fail ArgumentError,
          'id must be set to a valid string' if id.nil?
        response = @client.send_request(
          method: 'GET',
          url: SEGMENTS_URL + id,
          content_type: 'application/json',
          version: 3
        )
        logger.info("Retrieved segment information for #{id}")
        @id = id
        @criteria = response['body']['criteria']
        @display_name = response['body']['display_name']
        response
      end

      # Update a segment with new criteria/display_name
      #
      # @ returns [Object] response HTTP response
      def update
        fail ArgumentError,
          'id cannot be nil' if @id.nil?
        fail ArgumentError,
          'Either display_name or criteria must be set to a value' if display_name.nil? and criteria.nil?

        data = {}
        data['display_name'] = @display_name
        data['criteria'] = @criteria
        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(data),
          url: SEGMENTS_URL + @id,
          content_type: 'application/json',
          version: 3
        )
        logger.info { "Successful segment update: #{@display_name}" }
        response
      end

      # Delete a segment
      #
      # @ returns [Object] response HTTP response
      def delete
        url = SEGMENTS_URL + @id
        response = @client.send_request(
          method: 'DELETE',
          url: url,
          content_type: 'application/json',
          version: 3
        )
        logger.info { "Successful segment deletion: #{@display_name}" }
        response
      end
    end

    class SegmentList < Urbanairship::Common::PageIterator
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @next_page = SEGMENTS_URL
        @data_attribute = 'segments'
      end
    end
  end
end
