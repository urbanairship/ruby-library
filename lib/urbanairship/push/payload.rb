module Urbanairship
  module Push
    module Payload
      def notification(alert: nil)
        { alert: alert }
      end
    end
  end
end
