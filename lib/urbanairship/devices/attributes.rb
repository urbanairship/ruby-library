require 'urbanairship'

module Urbanairship
    module  Devices
        class Attributes
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor 

            def initialize(client: required('client'))
                @client = client
            end
            
        end
    end
end 