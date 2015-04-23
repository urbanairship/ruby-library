module Urbanairship
  module Push
    module Payload
      def notification(alert: nil, ios: nil, android: nil, amazon: nil, blackberry: nil, wns: nil, mpns: nil, actions: nil, interactive: nil)
        payload = {
          alert: alert,
          actions: actions,
          ios: ios,
          android: android,
          amazon: amazon,
          blackberry: blackberry,
          wns: wns,
          mpns: mpns,
          interactive: interactive
        }.keep_if { |_, value| !value.nil? }
        fail ArgumentError, 'Notification body may not be empty' if payload.empty?
        payload
      end

      def ios(alert: nil, badge: nil, sound: nil, extra: nil, expiry: nil, category: nil, interactive: nil, content_available: nil)
        {
          alert: alert,
          badge: badge,
          sound: sound,
          extra: extra,
          expiry: expiry,
          category: category,
          interactive: interactive,
          'content-available' => content_available
        }.keep_if { |_, value| !value.nil? }
      end
    end
  end
end
