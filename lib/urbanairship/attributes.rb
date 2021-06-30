
module Urbanairship
  class Attributes

    SET = 'set'

    def initialize(attributes)
      @attributes = attributes
    end

    def payload
      @payload ||= { attributes: attributes_list }
    end

    private

    def attributes_list
      @attributes.map(&:attribute_payload)
    end

    def attribute_payload(attribute)
      {
        action: attribute[:action] || SET,
        key: attribute[:key],
        value: attribute[:value],
        timestamp: timestamp,
      }
    end

    def timestamp
      @timestamp ||= Time.now.utc
    end
  end
end
