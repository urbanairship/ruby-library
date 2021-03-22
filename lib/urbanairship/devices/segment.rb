require 'json'
require 'urbanairship'


module Urbanairship
  module Devices
    class Segment
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :display_name, :criteria
      attr_reader :id

      def initialize(client: required('client'))
        @client = client
      end

      # Build a Segment from the display_name and criteria attributes
      #
      # @param [Object] client The Client
      # @return [Object] response HTTP response
      def create
        fail ArgumentError,
          'Both display_name and criteria must be set to a value' if display_name.nil? or criteria.nil?
        payload = {
          'display_name': display_name,
          'criteria': criteria
        }
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: segments_path,
          content_type: 'application/json'
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
          path: segments_path(id)
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
        data['display_name'] = display_name
        data['criteria'] = criteria
        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(data),
          path: segments_path(@id),
          content_type: 'application/json'
        )
        logger.info { "Successful segment update: #{@display_name}" }
        response
      end

      # Delete a segment
      #
      # @ returns [Object] response HTTP response
      def delete
        fail ArgumentError, 'id cannot be nil' if id.nil?

        response = @client.send_request(
          method: 'DELETE',
          path: segments_path(id)
        )
        logger.info { "Successful segment deletion: #{@display_name}" }
        response
      end
    end

    class SegmentList < Urbanairship::Common::PageIterator
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @next_page_path = segments_path
        @data_attribute = 'segments'
      end
    end
  end
end
