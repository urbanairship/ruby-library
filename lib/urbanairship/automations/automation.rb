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
                params = []
                params << ['limit', limit] if limit
                params << ['enabled', enabled] if enabled
                params << ['offset', offset] if offset
                query = URI.encode_www_form(params)
                PIPELINES_URL + '?' + query
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