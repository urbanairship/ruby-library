require 'urbanairship'
require 'urbanairship/automations/pipeline'

module Urbanairship
    module Automations
        class CreateAndSend
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor :limit,
                          :enabled,
                          :offset

            def initialize(client: required('client'))
                 @client = client
            end

            def list_automations
                response = @client.send_request(
                method: 'GET',
                url: PIPELINES_URL
                )
                logger.info("Looking up email channel with address #{address}")
                response
            end
        end
    end
end