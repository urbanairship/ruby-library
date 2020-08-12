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
                          :pipeline_id,
                          :pipeline_object

            def initialize(client: required('client'))
                 @client = client
            end

            def create_automation
                response = @client.send_request(
                    method: 'POST',
                    body: JSON.dump(pipeline_object),
                    url: PIPELINES_URL,
                    content_type: 'application/json'
                )
                logger.info("Created Automation")
                response
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

            def validate_automation
                response = @client.send_request(
                    method: 'POST',
                    body: JSON.dump(pipeline_object),
                    url: PIPELINES_URL + 'validate',
                    content_type: 'application/json'
                )
                logger.info("Validating Automation")
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

            def update_automation
                fail ArgumentError, 'pipeline_id must be set to update individual automation' if @pipeline_id.nil?
                
                response = @client.send_request(
                    method: 'PUT',
                    body: JSON.dump(pipeline_object),
                    url: PIPELINES_URL + pipeline_id,
                    content_type: 'application/json'
                )
                logger.info("Validating Automation")
                response
            end

            def delete_automation 
                fail ArgumentError, 'pipeline_id must be set to delete individual automation' if @pipeline_id.nil?
                response = @client.send_request(
                    method: 'DELETE',
                    url: PIPELINES_URL + pipeline_id
                )
                logger.info("Deleting automation with id #{pipeline_id}")
                response
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
        end
    end
end