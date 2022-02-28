require 'urbanairship'
require 'tempfile'

module Urbanairship
  module Devices
    class TagList
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :name

      def initialize(client: required('client'))
        fail ArgumentError, 'Client cannot be set to nil' if client.nil?
        @client = client
      end

      def create(description: nil, extra: nil, add:nil, remove: nil, set: nil)
        fail ArgumentError, 'Name must be set' if name.nil?
        payload = {'name': name}
        payload['description'] = description unless description.nil?
        payload['extra'] = extra unless extra.nil?
        payload['add'] = add unless add.nil?
        payload['remove'] = remove unless remove.nil?
        payload['set'] = set unless set.nil?

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: tag_lists_path,
          content_type: 'application/json'
        )
        logger.info("Created Tag List for #{@name}")
        response
      end

      def upload(csv_file: required('csv_file'), gzip: false)
        fail ArgumentError, 'Name must be set' if name.nil?

        if gzip
          response = @client.send_request(
            method: 'PUT',
            body: csv_file,
            path: tag_lists_path(@name + '/csv/'),
            content_type: 'text/csv',
            encoding: gzip
          )
        else
          response = @client.send_request(
            method: 'PUT',
            body: csv_file,
            path: tag_lists_path(@name + '/csv/'),
            content_type: 'text/csv'
          )
        end

        logger.info("Uploaded a tag list for #{@name}")
        response
      end

      def errors
        fail ArgumentError, 'Name must be set' if name.nil?

        response = @client.send_request(
          method: 'GET',
          path: tag_lists_path(@name + '/errors/')
        )
        logger.info("Got error CSV for tag list #{@name}")
        response
      end

      def list
        fail ArgumentError, 'Name must be set' if name.nil?

        response = @client.send_request(
          method: 'GET',
          path: tag_lists_path
        )
        logger.info("Got tag lists listing")
        response
      end
    end
  end
end
