require 'urbanairship/util'

module Urbanairship
  module Push
    module Schedule
      def scheduled_time(datetime)
        payload(:scheduled_time, datetime)
      end

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
