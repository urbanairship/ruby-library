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

      private

      def payload(name, time)
        { name => Util.time_format(time) }
      end
    end
  end
end
