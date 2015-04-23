module Urbanairship
  module Push
    module Payload

      def notification(alert: nil, ios: nil)
        if alert
          { alert: alert }
        elsif ios
          { ios: ios }
        end
      end

      def ios(alert: nil, badge: nil, sound: nil, extra: nil, expiry: nil, category: nil, interactive: nil)
        {
          alert: alert,
          badge: badge,
          sound: sound,
          extra: extra,
          expiry: expiry,
          category: category,
          interactive: interactive
        }
          .keep_if { |_, value| !value.nil? }
      end
    end
  end
end
