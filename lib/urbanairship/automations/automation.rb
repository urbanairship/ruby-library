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
                          :offset,
                          :start,
                          :pipeline_id

            def initialize(client: required('client'))
                 @client = client
            end

            def format_url_with_params
                params = []
                params << ['limit', limit] if limit
                params << ['enabled', enabled] if enabled
                params << ['offset', offset] if offset
                params << ['start', start] if start
                query = URI.encode_www_form(params)
                '?' + query
            end

            def list_automations
                response = @client.send_request(
                    method: 'GET',
                    url: PIPELINES_URL + format_url_with_params
                )
                logger.info("Looking up automations for project")
                response
            end

            def list_deleted_automations
                response = @client.send_request(
                    method: 'GET',
                    url: PIPELINES_URL + 'deleted' + format_url_with_params
                )
                logger.info("Looking up deleted automations for project")
                response
            end

            def lookup_automation 
                fail ArgumentError, 'pipeline_id must be set to lookup individual automation' if @pipeline_id.nil?
                response = @client.send_request(
                    method: 'GET',
                    url: PIPELINES_URL + pipeline_id
                )
                logger.info("Looking up automation with id #{pipeline_id}")
                response
            end
        end
    end
end