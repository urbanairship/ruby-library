require 'urbanairship'
require 'urbanairship/devices/channel_tags'

module Urbanairship
  module  Devices
    class Email
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :address,
                    :commercial_opted_in,
                    :commercial_opted_out,
                    :locale_country,
                    :locale_language,
                    :timezone,
                    :transactional_opted_in,
                    :transactional_opted_out,
                    :type,
                    :channel_id

      def initialize(client: required('client'))
        @client = client
      end

      def register
        fail ArgumentError, 'address must be set to register email channel' if @address.nil?

        payload = {
          'channel': {
            'address': address,
            'commercial_opted_in': commercial_opted_in,
            'commercial_opted_out': commercial_opted_out,
            'locale_country': locale_country,
            'locale_language': locale_language,
            'timezone': timezone,
            'transactional_opted_in': transactional_opted_in,
            'transactional_opted_out': transactional_opted_out,
            'type': type
          }
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: channel_path('email'),
          content_type: 'application/json'
        )
        logger.info("Registering email channel with address #{address}")
        response
      end

      def uninstall
        fail ArgumentError, 'address must be set to register email channel' if @address.nil?

        payload = {
          'email_address': address
        }

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          path: channel_path('email/uninstall'),
          content_type: 'application/json'
        )
        logger.info("Uninstalling email channel with address #{address}")
        response
      end

      def lookup
        fail ArgumentError, 'address must be set to lookup email channel' if @address.nil?

        response = @client.send_request(
          method: 'GET',
          path: channel_path('email/' + address)
        )
        logger.info("Looking up email channel with address #{address}")
        response
      end

      def update
        fail ArgumentError, 'address must be set to update email channel' if channel_id.nil?

        channel_data =  {
          'address': address,
          'commercial_opted_in': commercial_opted_in,
          'commercial_opted_out': commercial_opted_out,
          'localte_country': locale_country,
          'locale_language': locale_language,
          'timezone': timezone,
          'transactional_opted_in': transactional_opted_in,
          'transactional_opted_out': transactional_opted_out,
          'type': type
      }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs

        payload = {'channel': channel_data}

        response = @client.send_request(
          method: 'PUT',
          path: channel_path('email/' + channel_id),
          body: JSON.dump(payload),
          content_type: 'application/json'
        )
        logger.info("Updating email channel with address #{@address}")
        response
      end
    end

    class EmailTags < ChannelTags
      include Urbanairship::Common

      def initialize(client: required('client'))
        super(client: client)
        @path = channel_path('email/tags')
      end

      def set_audience(email_address: required('email_address'))
        @audience['email_address'] = email_address
      end
    end

  end
end
