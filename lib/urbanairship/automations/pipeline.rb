require 'urbanairship'

module Urbanairship
  module Automations
    class Pipeline
      include Urbanairship::Common
      include Urbanairship::Loggable
      attr_accessor 
      :activation_time,
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
      :url

      def initialize(enabled, outcome)
        @enabled = enabled
        @outcome = outcome
      end

      
    end
  end
end