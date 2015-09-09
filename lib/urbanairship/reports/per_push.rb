require 'urbanairship'
require 'time'


module Urbanairship
  module Reports
    class PerPushDetail
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def get_single(push_id: required('push_id'))
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

      def get_batch(push_ids: required('push_ids'))
        fail ArgumentError,
             'push_ids must be an array' unless push_ids.kind_of?(Array)
        fail ArgumentError,
           'push_ids cannot be empty' if push_ids.empty?
        fail ArgumentError,
          'push_ids cannot contain more than 100 IDs' if push_ids.count > 100

        response = @client.send_request(
          method: 'POST',
          body: JSON.dump('push_ids' => push_ids),
          url: REPORTS_URL + 'perpush/detail/',
          content_type: 'application/json'
        )
        logger.info("Requested info for push ids: #{push_ids}")
        response
      end
    end

    class PerPushSeries
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required)
        @client = client
      end

      def get(push_id: required('push_id'), precision:nil, start_date:nil, end_date:nil)
        fail ArgumentError,
           'push_id cannot be empty' if push_id.nil?
        url = REPORTS_URL + 'perpush/series/' + push_id

        if precision
          precision_array = %w(HOURLY DAILY MONTHLY)
          fail ArgumentError,
             "Precision must be 'HOURLY', 'DAILY', or 'MONTHLY'" unless precision_array.include?(precision)
          url += '?precision=' + precision
        end

        if start_date
          fail ArgumentError,
             'Precision must be included with start date' if precision.nil?
          start_parsed = nil
          end_parsed = nil

          begin
            start_parsed = Time.parse(start_date)
            end_parsed = Time.parse(end_date) unless end_date.nil?
          rescue ArgumentError
            fail ArgumentError,
               'start_date and end_date must be valid date strings'
          end

          fail ArgumentError,
             'End date must be after start date' if !end_date.nil? and end_parsed <= start_parsed
          url += '&start=' + start_parsed.iso8601
          url += '&end=' + end_parsed.iso8601 unless end_parsed.nil?
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


