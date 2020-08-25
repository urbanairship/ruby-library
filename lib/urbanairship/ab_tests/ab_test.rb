require 'uri'
require 'urbanairship'
require 'urbanairship/ab_tests/experiment'

module Urbanairship
    module  AbTests
        class AbTest
        include Urbanairship::Common
        include Urbanairship::Loggable
        attr_accessor :limit,
                      :offset,
                      :experiment_object,
                      :experiment_id
                      
            def initialize(client: required('client'))
                @client = client
            end

            def list_ab_test
                response = @client.send_request(
                    method: 'GET',
                    url: EXPERIMENTS_URL + format_url_with_params
                )
                logger.info("Looking up A/B Tests for project")
                response
            end

            def create_ab_test
                response = @client.send_request(
                    method: 'POST',
                    body: JSON.dump(experiment_object),
                    url: EXPERIMENTS_URL,
                    content_type: 'application/json'
                )
                logger.info("Created A/B Test")
                response
            end

            def list_scheduled_ab_test
                response = @client.send_request(
                    method: 'GET',
                    url: EXPERIMENTS_URL + 'scheduled' + format_url_with_params
                )
                logger.info("Looking up scheduled A/B Tests for project")
                response
            end

            def delete_ab_test
                fail ArgumentError, 'experiment_id must be set to delete individual A/B test' if @experiment_id.nil?
                response = @client.send_request(
                    method: 'DELETE',
                    url: EXPERIMENTS_URL + 'scheduled/' + experiment_id
                )
                logger.info("Deleting A/B test with ID #{experiment_id}")
                response
            end

            def validate_ab_test
                response = @client.send_request(
                    method: 'POST',
                    body: JSON.dump(experiment_object),
                    url: EXPERIMENTS_URL + 'validate',
                    content_type: 'application/json'
                )
                logger.info("Validating A/B Test")
                response
            end

            def lookup_ab_test
                fail ArgumentError, 'experiment_id must be set to lookup individual A/B Test' if @experiment_id.nil?
                response = @client.send_request(
                    method: 'GET',
                    url: EXPERIMENTS_URL + experiment_id
                )
                logger.info("Looking up A/B test with ID #{experiment_id}")
                response
            end

            def format_url_with_params
                params = []
                params << ['limit', limit] if limit
                params << ['offset', offset] if offset
                query = URI.encode_www_form(params)
                '?' + query
            end
        end
    end
end 
    