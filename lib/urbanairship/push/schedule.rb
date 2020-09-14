require 'urbanairship/util'


module Urbanairship
  module Push
    module Schedule
      # Select a date and time for Scheduled Push
      def scheduled_time(datetime)
        payload(:scheduled_time, datetime)
      end

      # Select a local date and time for Scheduled Push
      def local_scheduled_time(datetime)
        payload(:local_scheduled_time, datetime)
      end

      # Uses predictive analysis to send push at optimal time
      def best_scheduled_time(date)
        {
          'best_time': {
            'send_date': date
          }
        }
      end

      private

      def payload(name, time)
        { name => Util.time_format(time) }
      end
    end
  end
end
