require 'json'

# In the Python library, this file is named `core.py`. Here it's
# `push.rb` in keeping with the Ruby convention of naming the
# file based on the class it contains.
module Urbanairship
  module Push
    # A push notification.
    class Push
      attr_writer :audience, :notification, :options, :device_types, :message

      def initialize(airship)
        @airship = airship
      end

      def payload
        {
          audience: @audience,
          notification: @notification,
          options: @options,
          device_types: @device_types,
          message: @message
        }.compact
      end
    end


    class ScheduledPush
      attr_writer :schedule, :name, :push, :url

      def initialize(airship)
        @airship = airship
      end

      def payload
        {
          name: @name,
          schedule: @schedule,
          push: @push.payload
        }.compact
      end
    end


    class PushResponse
      attr_reader :ok, :push_ids, :schedule_url, :operation_id, :payload

      def initialize(http_response_body:)
        response = JSON.load(http_response_body)
        @ok = response['ok']
        
      end
    end

  end
end
