require 'urbanairship'


module Urbanairship
  module Devices
    class ChannelTags
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_writer :client
      attr_reader :audience, :add_group, :remove_group, :set_group

      def initialize(client)
        @client = client
        @audience = {}
        @add_group = {}
        @remove_group = {}
        @set_group = {}
        @url = CHANNEL_URL + 'tags/'
      end

      def set_audience(ios: nil, android: nil, amazon: nil)
        if ios
          @audience['ios_channel'] = ios
        end
        if android
          @audience['android_channel'] = android
        end
        if amazon
          @audience['amazon_channel'] = amazon
        end
      end

      def add(group_name, tags)
        @add_group[group_name] = tags
      end

      def remove(group_name, tags)
        @remove_group[group_name] = tags
      end

      def set(group_name, tags)
        @set_group[group_name] = tags
      end

      def send_request
        payload = {}

        fail ArgumentError,
          'An audience is required for modifying tags' if @audience.empty?
        fail ArgumentError,
          'A tag request cannot both add and set tags' if !@add_group.empty? and !@set_group.empty?
        fail ArgumentError,
          'A tag request cannot both remove and set tags' if !@remove_group.empty? and !@set_group.empty?
        fail ArgumentError,
          'A tag request must add, remove, or set a tag' if @remove_group.empty? and @add_group.empty? and @set_group.empty?

        payload['audience'] = @audience
        payload['add'] = @add_group if !@add_group.empty?
        payload['remove'] = @remove_group if !@remove_group.empty?
        payload['set'] = @set_group if !@set_group.empty?

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(payload),
          url: @url,
          content_type: 'application/json'
        )
        logger.info("Set tags for audience: #{@audience}")
        response
      end
    end
  end
end






