require 'urbanairship'
require 'urbanairship/common'

module Urbanairship
  module CustomEvents
    module Payload
      include Urbanairship::Common

      def custom_events(
            body: required('body'),
            occurred: required('occurred'),
            user: required('user')
          )
        compact_helper({
          body: body,
          occurred: format_timestamp(occurred),
          user: user
        })
      end

      # Body specific portion of CustomEvent Object
      def custom_events_body(
            interaction_id: nil, interaction_type: nil, name: required('name'),
            properties: nil, session_id: nil, transaction: nil, value: nil
          )

        validates_name_format(name)
        validates_value_format(value)

        compact_helper({
          interaction_id: interaction_id,
          interaction_type: interaction_type,
          name: name,
          properties: properties,
          session_id: session_id,
          transaction: transaction,
          value: value
        })
      end

      # User specific portion of CustomEvent Object
      def custom_events_user(
            amazon_channel: nil, android_channel: nil, channel: nil,
            ios_channel: nil, named_user_id: nil, web_channel: nil
          )
        res = compact_helper({
            amazon_channel: amazon_channel,
            android_channel: android_channel,
            channel: channel,
            ios_channel: ios_channel,
            named_user_id: named_user_id,
            web_channel: web_channel,
          })

        fail ArgumentError, 'at least one user identifier must be defined' if res.empty?

        res
      end


      # Formatters
      # ------------------------------------------------------------------------

      def format_timestamp(timestamp)
        return timestamp if timestamp.is_a?(String)

        timestamp.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
      end


      # Validators
      # ------------------------------------------------------------------------

      NAME_REGEX = /^[a-z0-9_\-]+$/
      def validates_name_format(name)
        return if name =~ NAME_REGEX

        fail ArgumentError, 'invalid "name": it must follows this pattern /^[a-z0-9_\-]+$/'
      end

      def validates_value_format(value)
        return if value.nil?
        return if value.is_a?(Numeric)

        fail ArgumentError, 'invalid "value": must be a number'
      end
    end
  end
end
