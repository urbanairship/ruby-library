require 'urbanairship'

module Urbanairship
    module  AbTests
        class Experiment
        include Urbanairship::Common
        include Urbanairship::Loggable
        attr_accessor :description
                      :id 
                      :name
                      :push
                      :schedule
                      :weight

        def initialize(client: required('client'))
            @client = client
        end

        end 
    end 
end