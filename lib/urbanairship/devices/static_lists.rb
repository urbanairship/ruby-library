require 'urbanairship'
require 'tempfile'


module Urbanairship
  module Devices
    class StaticList
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'), name: required('name'))
        fail ArgumentError,
           'Neither client nor name can be set to nil' if client.nil? or name.nil?
        @client = client
        @name = name
      end

      def create(description: nil, extras: nil)
        payload = {'name' => @name}
        payload['description'] = description unless description.nil?
        payload['extras'] = extras unless extras.nil?

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: LISTS_URL,
          content_type: 'application/json'
        )
        logger.info("Created static list for #{@name}")
        response
      end

      def upload(csv_file: required('csv_file'))
        Tempfile.open('ua_upload.gz') do |temp|
          Zlib::GzipWriter.open(temp) do |gz|
            gz.write IO.binread(csv_file)
          end
          response = @client.send_request(
            method: 'PUT',
            body: temp,
            url: LISTS_URL + @name + '/csv/',
            content_type: 'text/csv',
            encoding: 'gzip'
          )
          logger.info("Uploading a list for #{@name}")
          response
        end
      end

      def update(description: nil, extras: nil)
        fail ArgumentError,
           'Either description or extras must be set to a value' if description.nil? and extras.nil?
        payload = {}
        payload['description'] = description unless description.nil?
        payload['extras'] = extras unless extras.nil?
        response = @client.send_request(
          method: 'PUT',
          body: JSON.dump(payload),
          url: LISTS_URL + @name,
          content_type: 'application/json'
        )
        logger.info("Updating the metadata for list #{@name}")
        response
      end

      def lookup
        response = @client.send_request(
          method: 'GET',
          url: LISTS_URL + @name
        )
        logger.info("Retrieving info for list #{@name}")
        response
      end

      def delete
        response = @client.send_request(
          method: 'DELETE',
          url: LISTS_URL + @name
        )
        logger.info("Deleted list #{@name}")
        response
      end
    end

    class StaticLists < Urbanairship::Common::PageIterator
      def initialize(client: required('client'))
        super(client: client)
        @next_page = LISTS_URL
        @data_attribute = 'lists'
      end
    end
  end
end
