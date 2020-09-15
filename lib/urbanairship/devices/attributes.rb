require 'urbanairship'

module Urbanairship
    module  Devices
        class Attributes
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor :attribute,
                          :operator,
                          :is_empty,
                          :before,
                          :after,
                          :range,
                          :equals,
                          :precision,
                          :value

            def initialize(client: required('client'))
                @client = client
            end

            def payload
                {
                    
                }
            end

        end
    end
end 