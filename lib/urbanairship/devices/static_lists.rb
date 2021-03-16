require 'urbanairship'
require 'tempfile'


module Urbanairship
  module Devices
    class StaticList
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :name
      def initialize(client: required('client'))
        fail ArgumentError, 'Client cannot be set to nil' if client.nil?
        @client = client
      end

      def create(description: nil, extra: nil)
        fail ArgumentError, 'Name must be set' if name.nil?
        payload = {'name': name}
        payload['description'] = description unless description.nil?
        payload['extra'] = extra unless extra.nil?

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: lists_url,
          content_type: 'application/json'
        )
        logger.info("Created static list for #{@name}")
        response
      end

      def upload(csv_file: required('csv_file'), gzip: false)
        fail ArgumentError, 'Name must be set' if name.nil?
        if gzip
          response = @client.send_request(
              method: 'PUT',
              body: csv_file,
              url: lists_url(@name + '/csv/'),
              content_type: 'text/csv',
              encoding: gzip
          )
        else
          response = @client.send_request(
              method: 'PUT',
              body: csv_file,
              url: lists_url(@name + '/csv/'),
              content_type: 'text/csv'
          )
        end
        logger.info("Uploading a list for #{@name}")
        response
      end

      def update(description: nil, extra: nil)
        fail ArgumentError, 'Name must be set' if name.nil?
        fail ArgumentError,
           'Either description or extras must be set to a value' if description.nil? and extra.nil?
        payload = {}
        payload['description'] = description unless description.nil?
        payload['extra'] = extra unless extra.nil?
        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(payload),
          url: lists_url(@name),
          content_type: 'application/json'
        )
        logger.info("Updating the metadata for list #{@name}")
        response
      end

      def lookup
        fail ArgumentError, 'Name must be set' if name.nil?
        response = @client.send_request(
          method: 'GET',
          url: lists_url(@name)
        )
        logger.info("Retrieving info for list #{@name}")
        response
      end

      def delete
        fail ArgumentError, 'Name must be set' if name.nil?
        response = @client.send_request(
          method: 'DELETE',
          url: lists_url(@name)
        )
        logger.info("Deleted list #{@name}")
        response
      end
    end

    class StaticLists < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = lists_url
        @data_attribute = 'lists'
      end
    end
  end
end
