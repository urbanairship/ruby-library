require 'urbanairship'

module Urbanairship
  module Devices
    class OpenChannel
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :channel_id,
                    :open_platform,
                    :opt_in,
                    :address,
                    :tags,
                    :identifiers,
                    :template_id,
                    :alert,
                    :extra,
                    :media_attachment,
                    :summary,
                    :title,
                    :template_id,
                    :fields,
                    :interactive,
                    :platform_alert

      def initialize(client: required('client'))
        @client = client
      end

      def create()
        fail TypeError, 'address must be set to create open channel' unless address.is_a? String
        fail TypeError, 'open_platform must be set to create open channel' unless open_platform.is_a? String
        fail TypeError, 'opt_in must be boolean' unless [true, false].include? opt_in

        channel_data = {
          'type': 'open',
          'open': {:open_platform_name => open_platform},
          'opt_in': opt_in,
          'address': address,
          'tags': tags
        }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs

        set_identifiers

        body = {'channel': channel_data}

        response = @client.send_request(
          method: 'POST',
          url: open_channel_url,
          body: JSON.dump(body),
          content_type: 'application/json'
        )
        logger.info("Registering open channel with address: #{address}")
        response
      end

      def update(set_tags: required('set_tags'))
        fail ArgumentError, 'set_tags must be boolean' unless [true, false].include? set_tags
        fail ArgumentError, 'set_tags cannot be true when tags are not set' unless set_tags == true && tags != nil
        fail TypeError, 'opt_in must be boolean' unless [true, false].include? opt_in
        fail TypeError, 'address or channel_id must not be nil' unless address.is_a? String || channel_id.is_a?(String)
        fail TypeError, 'open_platform cannot be nil' unless open_platform.is_a? String
        fail TypeErorr, 'address must not be nil if opt_in is true' unless opt_in.is_a? TrueClass

        channel_data = {
          'type': 'open',
          'open': {'open_platform_name': open_platform},
          'opt_in': opt_in,
          'set_tags': set_tags,
          'channel_id': channel_id,
          'address': address,
          'tags': tags
        }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs

        set_identifiers

        body = {'channel': channel_data}

        response = @client.send_request(
          method: 'POST',
          url: open_channel_url,
          body: JSON.dump(body),
          content_type: 'application/json'
        )
        logger.info("Updating open channel with address #{address}")
        response
      end

      def lookup(channel_id: required('channel_id'))
        fail ArgumentError, 'channel_id needs to be a string' unless channel_id.is_a? String

        response = @client.send_request(
          method: 'GET',
          path: channel_path(channel_id)
        )
        logger.info("Looking up info on device token #{channel_id}")
        response
      end

      def notification_with_template_id
        fail TypeError, 'open_platform cannot be nil' if open_platform.nil?

        if alert
          payload = {
            "open::#{open_platform}":{
              'template': {
                'template_id': template_id,
                'fields': {
                  'alert': alert
                }
              }
            }
          }
        else
          payload = {
            "open::#{open_platform}":{
              'template': {
                'template_id': template_id,
              }
            }
          }
        end

        payload
      end

      def open_channel_override
        fail TypeError, 'open_platform cannot be nil' if open_platform.nil?
        payload = {
            'alert': platform_alert,
            'extra': extra,
            'media_attachment': media_attachment,
            'summary': summary,
            'title': title,
            'interactive': interactive
          }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs

        {'alert': alert,
         "open::#{open_platform}": payload}
      end

      def set_identifiers
        if identifiers
          channel_data[:open][:identifiers] = identifiers
        end
      end

    end
  end
end
