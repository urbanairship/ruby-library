require 'urbanairship'

module Urbanairship
    module  Experiments
        class Experiment
        include Urbanairship::Common
        include Urbanairship::Loggable
        attr_accessor :audience,
                      :campagins,
                      :control,
                      :created_at,
                      :description,
                      :device_types,
                      :id, 
                      :name,
                      :push_id,
                      :variants
                      
        def initialize(client: required('client'))
            @client = client
            @variants = []
        end

        end
    end
end