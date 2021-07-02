
module Urbanairship
  module  Devices
    class Attributes

      SET = 'set'
      REMOVE = 'remove'

      def initialize(attributes)
        @attributes = attributes
      end

      def payload
        @payload ||= { attributes: attributes_list }
      end

      private

      def attributes_list
        @attributes.map{ |attribute| attribute_payload(attribute) }
      end

      def attribute_payload(attribute)
        if REMOVE == attribute[:action]
          remove_payload(attribute)
        else
          set_payload(attribute)
        end
      end

      def set_payload(attribute)
        {
          action: SET,
          key: attribute[:key],
          value: attribute[:value],
          timestamp: (attribute[:timestamp] || timestamp).iso8601,
        }
      end

      def remove_payload(attribute)
        {
          action: REMOVE,
          key: attribute[:key],
          timestamp: (attribute[:timestamp] || timestamp).iso8601,
        }
      end

      def timestamp
        @timestamp ||= Time.now.utc
      end
    end
  end
end
