require 'urbanairship'


module Urbanairship
  module Devices
    class NamedUser
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :named_user_id

      def initialize(client: required('client'))
        @client = client
        @named_user_id =  nil
      end

      def associate(channel_id: required('channel_id'), device_type: nil)
        fail ArgumentError,
             'named_user_id is required for association' if @named_user_id.nil?

        payload = {}
        payload['channel_id'] = channel_id
        payload['device_type'] = device_type unless device_type.nil?
        payload['named_user_id'] = @named_user_id.to_s

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: named_users_path('associate'),
          content_type: 'application/json'
        )
        logger.info { "Associated channel_id #{channel_id} with named_user #{@named_user_id}" }
        response
      end

      def disassociate(channel_id: required('channel_id'), device_type: nil)
        payload = {}
        payload['channel_id'] = channel_id
        payload['device_type'] = device_type unless device_type.nil?
        payload['named_user_id'] = @named_user_id unless @named_user_id.nil?
        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: named_users_path('/disassociate'),
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
            path: named_users_path('?id=' + @named_user_id),
        )
        logger.info { "Retrieved information on named_user_id #{@named_user_id}" }
        response
      end
    end


    class NamedUserTags < ChannelTags
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @path = named_users_path('tags/')
      end

      def set_audience(user_ids: required('user_ids'))
        @audience['named_user_id'] = user_ids
      end
    end


    class NamedUserList < Urbanairship::Common::PageIterator
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @next_page_path = named_users_path
        @data_attribute = 'named_users'
      end
    end

    class NamedUserUninstaller
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :named_user_ids

      def initialize(client: required('client'))
        @client = client
        @named_user_ids =  nil
      end

      def uninstall
        payload = {}
        payload['named_user_id'] = @named_user_ids

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: named_users_path('/uninstall'),
          content_type: 'application/json'
        )
        logger.info { "Uninstalled named_user_ids #{@named_user_ids} " }
        response
      end
    end
  end
end
