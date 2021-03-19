require 'urbanairship'
require 'time'

module Urbanairship
  module Reports
    class Helper
      def get_period_params(start_date, end_date, precision)
        fail ArgumentError,
           'the parameters cannot be set to nil' if start_date.nil? or end_date.nil? or precision.nil?
        precision_array = %w(HOURLY DAILY MONTHLY)
        fail ArgumentError,
             "Precision must be 'HOURLY', 'DAILY', or 'MONTHLY'" unless precision_array.include?(precision)

        begin
          start_parsed = Time.parse(start_date)
          end_parsed = Time.parse(end_date)
        rescue ArgumentError
          fail ArgumentError,
             'start_date and end_date must be valid date strings'
        end
        url = '?start=' + start_parsed.iso8601 + '&end=' + end_parsed.iso8601
        url += '&precision=' + precision
      end
    end

    class IndividualResponseStats
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def get(push_id: required('push_id'))
        fail ArgumentError,
           'push_id cannot be nil' if push_id.nil?

        path = reports_path('responses/' + push_id)
        response = @client.send_request(method: 'GET', path: path)
        logger.info("Retrieved info on push_id: #{push_id}")
        response
      end
    end

    class ResponseList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
          end_date: required('end_date'), limit: nil, push_id_start: nil)
        super(client: client)
        fail ArgumentError,
           'start_date and end_date are required fields' if start_date.nil? or end_date.nil?
        fail ArgumentError,
           'limit must be a number' if !limit.nil? and !limit.is_a? Numeric
        fail ArgumentError,
           'push_id_start must be a string' if !push_id_start.nil? and !push_id_start.is_a? String

        begin
          start_parsed = Time.parse(start_date)
          end_parsed = Time.parse(end_date)
        rescue ArgumentError
          fail ArgumentError,
               'start_date and end_date must be valid date strings'
        end
        path = reports_path('responses/list?start=' + start_parsed.iso8601 + '&end=' + end_parsed.iso8601)
        path += '&limit' + limit.to_s unless limit.nil?
        path += '&push_id_start&' + push_id_start unless push_id_start.nil?
        @next_page_path = path
        @data_attribute = 'pushes'
      end
    end

    class DevicesReport
      include Urbanairship::Common
      include Urbanairship::Loggable

      def initialize(client: required('client'))
        @client = client
      end

      def get(date: required('date'))
        fail ArgumentError,
           'date cannot be set to nil' if date.nil?
        begin
          date_parsed = Time.parse(date)
        rescue ArgumentError
          fail ArgumentError,
               'date must be a valid date string'
        end
        response = @client.send_request(
          method: 'GET',
          path: reports_path('devices/?date=' + date_parsed.iso8601)
        )
        logger.info("Retrieved device report for date #{date}")
        response
      end
    end

    class OptInList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('optins/' + period_params)
        @data_attribute = 'optins'
      end
    end

    class OptOutList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('optouts/' + period_params)
        @data_attribute = 'optouts'
      end
    end

    class PushList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('sends/' + period_params)
        @data_attribute = 'sends'
      end
    end

    class ResponseReportList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('responses/' + period_params)
        @data_attribute = 'responses'
      end
    end

    class AppOpensList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('opens/' + period_params)
        @data_attribute = 'opens'
      end
    end

    class TimeInAppList < Urbanairship::Common::PageIterator
      def initialize(client: required('client'), start_date: required('start_date'),
                     end_date: required('end_date'), precision: required('precision'))
        super(client: client)
        period_params = Helper.new.get_period_params(start_date, end_date, precision)
        @next_page_path = reports_path('timeinapp/' + period_params)
        @data_attribute = 'timeinapp'
      end
    end
  end
end
