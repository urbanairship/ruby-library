require 'urbanairship'

module Urbanairship
    module  Devices
        class Attribute
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
                if value.is_a? int 
                    number_attribute
                elsif value.is_a? string 
                    text_attribute
                elsif precision
                    date_attribute
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