require 'uri'
require 'urbanairship'
require 'urbanairship/automations/pipeline'

module Urbanairship
    module Automations
        class Automation
            include Urbanairship::Common
            include Urbanairship::Loggable
            attr_accessor :limit,
                          :enabled,
                          :offset

            def initialize(client: required('client'))
                 @client = client
            end

            def format_url_with_params
                query = URI.encode_www_form([["limit", limit], ["enabled", enabled], ["offset", offset]])
                PIPELINES_URL + query
            end

            def list_automations
                response = @client.send_request(
                method: 'GET',
                url: PIPELINES_URL 
                )
                logger.info("Looking up email channel with address #{address}")
                response
                # https://go.urbanairship.com/api/pipelines/?enabled=False&limit=2&offset=8
            end
        end
    end
end