require 'urbanairship'


module Urbanairship
  module Devices
    class NamedUser
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'), named_user_id: nil)
        @client = client
        @named_user_id = named_user_id
      end

      def associate(channel_id: required('channel_id'), device_type: required('device_type'))
        fail ArgumentError,
             'named_user_id is required for association' if @named_user_id.nil?

        payload = {}
        payload['channel_id'] = channel_id
        payload['device_type'] = device_type
        payload['named_user_id'] = @named_user_id

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: NAMED_USER_URL + '/associate',
          content_type: 'application/json'
        )
        logger.info { "Associated channel_id #{channel_id} with named_user #{@named_user_id}" }
        response
      end

      def disassociate(channel_id: required('channel_id'), device_type: required('device_type'))
        payload = {}
        payload['channel_id'] = channel_id
        payload['device_type'] = device_type
        payload['named_user_id'] = @named_user_id unless @named_user_id.nil?
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: NAMED_USER_URL + '/disassociate',
          content_type: 'application/json'
        )
        logger.info { "Dissociated channel_id #{channel_id}" }
        response
      end

      def lookup
        fail ArgumentError,
           'named_user_id is required for lookup' if @named_user_id.nil?
        response = @client.send_request(
            method: 'GET',
            url: NAMED_USER_URL + '?id=' + @named_user_id,
        )
        logger.info { "Retrieved information on named_user_id #{@named_user_id}" }
        response
      end
    end


    class NamedUserTags < ChannelTags
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @url = NAMED_USER_URL + 'tags/'
      end

      def set_audience(user_ids: required('user_ids'))
        @audience['named_user_id'] = user_ids
      end
    end


    class NamedUserList < Urbanairship::Common::PageIterator
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @next_page = NAMED_USER_URL
        @data_attribute = 'named_users'
        load_page
      end
    end
  end
end