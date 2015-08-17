require 'urbanairship'


module Urbanairship
  module Push
    class AutomatedMessage
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def create(pipelines: required('pipelines'))
        resp = @client.send_request(
          method: 'POST',
          url: PIPELINES_URL,
          body: JSON.dump(pipelines),
          content_type: 'application/json'
        )
        logger.info('Created an automated message: #{pipelines}')
        resp
      end

      def validate(pipelines: required('pipeline'))
        resp = @client.send_request(
          method: 'POST',
          url: PIPELINES_URL + 'validate',
          body: JSON.dump(pipelines),
          content_type: 'application/json'
        )
      end
    end
  end
end