require 'urbanairship'

module Urbanairship
    module  AbTests
        class Experiment
        include Urbanairship::Common
        include Urbanairship::Loggable
        attr_accessor :audience,
                      :campaigns,
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

            def payload
                fail ArgumentError, 'audience is required for experiment' if @audience.nil?
                fail ArgumentError, 'device_types is required for experiment' if @device_types.nil?
                fail ArgumentError, 'variant cannot be empty for experiment' if @variants.empty?

                {
                    'name': name,
                    'description': description,
                    'control': control,
                    'audience': audience,
                    'device_types': device_types,
                    'campaigns': campaigns,
                    'variants': variants,
                    'id': id,
                    'created_at': created_at,
                    'push_id': push_id
                } 
            end

        end
    end
end