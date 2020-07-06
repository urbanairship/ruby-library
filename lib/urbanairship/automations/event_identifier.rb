require 'urbanairship'

module Urbanairship
    module Automations
        class EventIdentifier
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor
            :simple_event_identifier
            :compound_event_identifier 
            
        end 
    end
end