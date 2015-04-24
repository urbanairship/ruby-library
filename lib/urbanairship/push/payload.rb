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

      def blackberry(alert: nil, body: nil, content_type: 'text/plain')
        { body: alert || body, content_type: content_type }
      end

      def wns_payload(alert: nil, toast: nil, tile: nil, badge: nil)
        payload = {
          alert: alert,
          toast: toast,
          tile: tile,
          badge: badge
        }.compact
        fail ArgumentError, 'Must specify one message type' if payload.size != 1
        payload
      end

      def mpns_payload(alert: nil, toast: nil, tile: nil)
        payload = {
          alert: alert,
          toast: toast,
          tile: tile
        }.compact
        fail ArgumentError, 'Must specify one message type' if payload.size != 1
        payload
      end

      def message(title:, body:, content_type: nil, content_encoding: nil, extra: nil, expiry: nil, icons: nil, options: nil)
        {
          title: title,
          body: body,
          content_type: content_type,
          content_encoding: content_encoding,
          extra: extra,
          expiry: expiry,
          icons: icons,
          options: options
        }
          .compact
      end

      def interactive(type:, button_actions: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?
        { type: type, button_actions: button_actions }.compact
      end

      def all_
        'all'
      end

      def device_types(types)
        types
      end

      def options(expiry:)
        { expiry: expiry }
      end

      def actions(add_tag: nil, remove_tag: nil, open_: nil, share: nil, app_defined: nil)
        {
          add_tag: add_tag,
          remove_tag: remove_tag,
          open: open_,
          share: share,
          app_defined: app_defined
        }.compact
      end
    end
  end
end
