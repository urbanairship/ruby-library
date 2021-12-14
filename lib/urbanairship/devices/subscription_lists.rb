require 'urbanairship'


module Urbanairship
  module Devices
    class SubscriptionLists
      include Urbanairship::Common
      include Urbanairship::Loggable
      SUBSCRIBE = "subscribe"

      def initialize(client: required('client'))
        @client = client
      end

      def subscribe(list_id, email_addresses)
        fail TypeError, 'list_id string must be privided' unless list_id.is_a? String
        fail TypeError, 'email_addresses array must be privided' unless email_addresses.is_a? Array
        fail TypeError, 'each email address must be a string' unless email_addresses&.all? { |email| email.is_a? String }

        subscribe_payload = payload(SUBSCRIBE, list_id, email_addresses)

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump(subscribe_payload),
          path: channel_path('subscription_lists'),
          content_type: 'application/json'
        )
        logger.info("Subscribed #{email_addresses.count} users to #{list_id}")

        response
      end

      private

      def payload(action, list_id, email_addresses)
        {
          subscription_lists: [
             {
                action: action,
                list_id: list_id
             }
          ],
          audience: {
             email_address: email_addresses
          }
        }
      end
    end
  end
end
