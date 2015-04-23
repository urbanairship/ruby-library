module Urbanairship
  module Push
    module Payload
      require 'ext/hash'

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
        }.compact
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
        }
          .compact
      end

      def amazon(alert: nil, consolidation_key: nil, expires_after: nil, extra: nil, title: nil, summary: nil, interactive: nil)
        {
          alert: alert,
          consolidation_key: consolidation_key,
          expires_after: expires_after,
          extra: extra,
          title: title,
          summary: summary,
          interactive: interactive
        }
          .compact
      end

      def android(alert: nil, collapse_key: nil, time_to_live: nil, extra: nil, delay_while_idle: nil, interactive: nil)
        {
          alert: alert,
          collapse_key: collapse_key,
          time_to_live: time_to_live,
          extra: extra,
          delay_while_idle: delay_while_idle,
          interactive: interactive
        }
          .compact
      end

    end
  end
end
