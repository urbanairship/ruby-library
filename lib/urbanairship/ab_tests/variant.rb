require 'urbanairship'

module Urbanairship
    module  AbTests
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
            fail ArgumentError, 'a push must be added to create a variant' if @push.nil?

            {
             'description': description,
             'id': id,
             'name': name,
             'push': push,
             'schedule': schedule,
             'weight': weight   
            }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs
        end

        end 
    end 
end