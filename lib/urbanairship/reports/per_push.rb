require 'urbanairship'


module Urbanairship
  module Reports
    class PerPushDetail
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client)
        @client = client
      end

      def get_single(push_id)
        fail ArgumentError,
           'push_id cannot be empty' if push_id.nil?
        url = REPORTS_URL + 'perpush/detail/' + push_id
        response = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Requested per-push details for #{push_id}")
        response
      end

      def get_batch(push_ids)
        fail ArgumentError,
           'push_ids cannot be empty' if push_ids.nil? or push_ids.empty?
        fail ArgumentError,
          'push_ids must be an array' if !push_ids.kind_of?(Array)
        fail ArgumentError,
          'push_ids cannot contain more than 100 IDs' if push_ids.count > 100

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump({ 'push_ids' => push_ids }),
          url: REPORTS_URL + 'perpush/detail/',
        )
        logger.info("Requested info for push ids: #{push_ids}")
        response
      end
    end

    class PerPushSeries
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client)
        @client = client
      end

      def get(push_id, precision=nil, start_date=nil, end_date=nil)
        fail ArgumentError,
           'push_id cannot be empty' if push_id.nil?
        url = REPORTS_URL + '/perpush/series'

        if precision
          precision_array = ['HOURLY', 'DAILY', 'MONTHLY']
          fail ArgumentError,
               "Precision must be 'HOURLY', 'DAILY', or 'MONTHLY'" if !precision_array.include?(precision)
          url += '?precision=' + precision
        end

        if start_date or end_date
          begin
            Time.parse(start_date)
            Time.parse(end_date)
          rescue ArgumentError
            fail ArgumentError,
                 'start_date and end_date must be valid date strings'
          end
          url += '?start=' + start_date + '?end=' + end_date
        end

        response = @client.send_request(
          method: 'GET',
          url: url
        )
        logger.info("Send per push series request for push_id #{push_id} and url #{url}")
        response
      end
    end
  end
end


