module Urbanairship
  module Push
    module Payload
      require 'urbanairship/common'

      include Urbanairship::Common

      # Notification Object for a Push Payload
      def notification(alert: nil, ios: nil, android: nil, amazon: nil,
                       blackberry: nil, wns: nil, mpns: nil, actions: nil,
                       interactive: nil)
        payload = compact_helper({
          alert: alert,
          actions: actions,
          ios: ios,
          android: android,
          amazon: amazon,
          blackberry: blackberry,
          wns: wns,
          mpns: mpns,
          interactive: interactive
        })
        fail ArgumentError, 'Notification body is empty' if payload.empty?
        payload
      end

      # iOS specific portion of Push Notification Object
      def ios(alert: nil, badge: nil, sound: nil, extra: nil, expiry: nil,
              category: nil, interactive: nil, content_available: nil, priority: nil)
        compact_helper({
          alert: alert,
          badge: badge,
          sound: sound,
          extra: extra,
          expiry: expiry,
          category: category,
          interactive: interactive,
          priority: priority,
          'content-available' => content_available
        })
      end

      # Amazon specific portion of Push Notification Object
      def amazon(alert: nil, consolidation_key: nil, expires_after: nil,
                 extra: nil, title: nil, summary: nil, interactive: nil)
        compact_helper({
          alert: alert,
          consolidation_key: consolidation_key,
          expires_after: expires_after,
          extra: extra,
          title: title,
          summary: summary,
          interactive: interactive
        })
      end

      # Android specific portion of Push Notification Object
      def android(alert: nil, collapse_key: nil, time_to_live: nil,
                  extra: nil, delay_while_idle: nil, interactive: nil)
        compact_helper({
          alert: alert,
          collapse_key: collapse_key,
          time_to_live: time_to_live,
          extra: extra,
          delay_while_idle: delay_while_idle,
          interactive: interactive
        })
      end

      # BlackBerry specific portion of Push Notification Object
      def blackberry(alert: nil, body: nil, content_type: 'text/plain')
        { body: alert || body, content_type: content_type }
      end

      # WNS specific portion of Push Notification Object
      def wns_payload(alert: nil, toast: nil, tile: nil, badge: nil)
        payload = compact_helper({
          alert: alert,
          toast: toast,
          tile: tile,
          badge: badge
        })
        fail ArgumentError, 'Must specify one message type' if payload.size != 1
        payload
      end

      # MPNS specific portion of Push Notification Object
      def mpns_payload(alert: nil, toast: nil, tile: nil)
        payload = compact_helper({
          alert: alert,
          toast: toast,
          tile: tile
        })
        fail ArgumentError, 'Must specify one message type' if payload.size != 1
        payload
      end

      # Rich Message specific portion of Push Notification Object
      def message(title: required('title'), body: required('body'), content_type: nil, content_encoding: nil,
                  extra: nil, expiry: nil, icons: nil, options: nil)
        compact_helper({
          title: title,
          body: body,
          content_type: content_type,
          content_encoding: content_encoding,
          extra: extra,
          expiry: expiry,
          icons: icons,
          options: options
        })
      end

      # Interactive Notification portion of Push Notification Object
      def interactive(type: required('type'), button_actions: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?
        compact_helper({ type: type, button_actions: button_actions })
      end

      def all
        'all'
      end

      # Target specified device types
      def device_types(types)
        types
      end

      # Expiry for a Rich Message
      def options(expiry: required('expiry'))
        { expiry: expiry }
      end

      # Actions for a Push Notification Object
      def actions(add_tag: nil, remove_tag: nil, open_: nil, share: nil,
                  app_defined: nil)
        compact_helper({
          add_tag: add_tag,
          remove_tag: remove_tag,
          open: open_,
          share: share,
          app_defined: app_defined
        })
      end
    end
  end
end
