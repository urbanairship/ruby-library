require 'urbanairship'

module Urbanairship
    module  Devices
        class Attribute
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor :attribute,
                          :operator,
                          :precision,
                          :value

            def initialize(client: required('client'))
                @client = client
            end

            def payload
                if precision
                    date_attribute
                elsif value.is_a? String
                    text_attribute
                elsif value.is_a? Integer 
                    number_attribute
                end
            end

            def number_attribute
                {
                    'attribute': attribute,
                    'operator': operator,
                    'value': value
                }
            end

            def text_attribute
                {
                    'attribute': attribute,
                    'operator': operator,
                    'value': value
                }
            end

            def date_attribute
                {
                    'attribute': attribute,
                    'operator': operator,
                    'precision': precision,
                    'value': value
                }
            end

        end
    end
end 