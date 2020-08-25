require 'urbanairship'

module Urbanairship
    module  Experiments
        class Variant
        include Urbanairship::Common
        include Urbanairship::Loggable
        attr_accessor :description,
                      :id,
                      :name,
                      :push,
                      :schedule,
                      :weight

        def initialize(client: required('client'))
            @client = client
        end

        def payload 
            {
             'description': description,
             'id': id,
             'name': name,
             'push': push,
             'schedule': schedule,
             'weight': weight   
            }
        end

        end 
    end 
end