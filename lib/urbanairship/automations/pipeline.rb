require 'urbanairship'

module Urbanairship
  module Automations
    class Pipeline
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor :activation_time,
                    :cancellation_trigger,
                    :condition,
                    :constraint,
                    :creation_time,
                    :deactivation_time,
                    :historical_trigger,
                    :immediate_trigger,
                    :last_modified_time,
                    :name,
                    :status,
                    :timing,
                    :url,
                    :enabled,
                    :outcome

      def initialize(client: required('client'))
        @client = client
      end

      def payload
        {
          activation_time: activation_time,
          cancellation_trigger: cancellation_trigger,
          condition: condition,
          constraint: constraint,
          creation_time: creation_time,
          deactivation_time: deactivation_time,
          enabled: enabled,
          historical_trigger: historical_trigger,
          immediate_trigger: immediate_trigger,
          last_modified_time: last_modified_time,
          name: name,
          outcome: outcome,
          status: status,
          timing: timing,
          url: url
        }.delete_if {|key, value| value.nil?} #this removes the nil key value pairs
      end
      
    end
  end
end