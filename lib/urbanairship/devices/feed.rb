require 'urbanairship'


module Urbanairship
  module Devices
    class Feed
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def create(url: required('url'), push: required('push'))
        fail ArgumentError, 'url needs to be a string' unless url.is_a? String
        fail ArgumentError, 'push needs to be a push object' unless push.is_a? Push::Push

        payload = { 'feed_url' => url, 'template' => push.payload }
        resp = @client.send_request(
          method: 'POST',
          url: FEEDS_URL,
          body: JSON.dump(payload),
          content_type: 'application/json'
        )
        logger.info("Created a feed for #{url} with template #{push.payload}")
        resp
      end

      def lookup(feed_id: required('feed_id'))
        fail ArgumentError, 'feed_id needs to be a string' unless feed_id.is_a? String
        resp = @client.send_request(
          method: 'GET',
          url: FEEDS_URL + feed_id,
        )
        logger.info("Retrieved info about feed #{feed_id}")
        resp
      end

      def update(feed_id: required('feed_id'), url: required('url'), push: required('push'))
        fail ArgumentError, 'feed_id needs to be a string' unless feed_id.is_a? String
        fail ArgumentError, 'push needs to be a push object' unless push.is_a? Push::Push
        fail ArgumentError, 'url needs to be a string' unless url.is_a? String

        payload = { 'feed_url' => url, 'template' => push.payload }
        resp = @client.send_request(
          method: 'PUT',
          url: FEEDS_URL + feed_id + '/',
          body: JSON.dump(payload),
          content_type: 'application/json'
        )
        logger.info("Updated feed_id #{feed_id} with push #{push}")
        resp
      end

      def delete(feed_id: required('feed_id'))
        fail ArgumentError, 'feed_id needs to be a string' unless feed_id.is_a? String

        resp = @client.send_request(
          method: 'DELETE',
          url: FEEDS_URL + feed_id + '/'
        )
        logger.info("Deleting feed #{feed_id}")
        resp
      end
    end
  end
end