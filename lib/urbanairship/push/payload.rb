module Urbanairship
  module Push
    module Payload
      require 'urbanairship/common'

      include Urbanairship::Common

      # Notification Object for a Push Payload
      def notification(alert: nil, ios: nil, android: nil, amazon: nil,
                       web: nil, wns: nil, open_platforms: nil,
                       actions: nil, interactive: nil, sms: nil)
        payload = compact_helper({
          alert: alert,
          ios: ios,
          android: android,
          amazon: amazon,
          web: web,
          wns: wns,
          actions: actions,
          interactive: interactive,
          sms: sms
        })
        if open_platforms
          open_platforms.each {|platform, overrides|
            payload[platform] = overrides
          }
        end
        fail ArgumentError, 'Notification body is empty' if payload.empty?
        payload
      end

      # iOS specific portion of Push Notification Object
      def ios(alert: nil, badge: nil, sound: nil, content_available: nil,
              extra: nil, expiry: nil, priority: nil, category: nil,
              interactive: nil, mutable_content: nil, media_attachment: nil,
              title: nil, subtitle: nil, collapse_id: nil)
        compact_helper({
          alert: alert,
          badge: badge,
          sound: sound,
          'content-available' => content_available,
          extra: extra,
          expiry: expiry,
          priority: priority,
          category: category,
          interactive: interactive,
          'mutable-content' => mutable_content,
          media_attachment: media_attachment,
          title: title,
          subtitle: subtitle,
          collapse_id: collapse_id
        })
      end

      # Amazon specific portion of Push Notification Object
      def amazon(alert: nil, consolidation_key: nil, expires_after: nil,
                 extra: nil, title: nil, summary: nil, interactive: nil, style: nil, sound: nil)
        compact_helper({
          alert: alert,
          consolidation_key: consolidation_key,
          expires_after: expires_after,
          extra: extra,
          title: title,
          summary: summary,
          interactive: interactive,
          style: style,
          sound: sound
        })
      end

      # Android specific portion of Push Notification Object
      def android(title: nil, alert: nil, summary: nil, extra: nil,
                  style: nil, icon: nil, icon_color: nil, notification_tag: nil,
                  notification_channel: nil, category: nil, visibility: nil,
                  public_notification: nil, sound: nil, priority: nil, collapse_key: nil,
                  time_to_live: nil, delivery_priority: nil, delay_while_idle: nil,
                  local_only: nil, wearable: nil, background_image: nil, extra_pages: nil,
                  interactive: nil)
        compact_helper({
          title: title,
          alert: alert,
          summary: summary,
          extra: extra,
          style: style,
          icon: icon,
          icon_color: icon_color,
          notification_tag: notification_tag,
          notification_channel: notification_channel,
          category: category,
          visibility: visibility,
          public_notification: public_notification,
          sound: sound,
          priority: priority,
          collapse_key: collapse_key,
          time_to_live: time_to_live,
          delivery_priority: delivery_priority,
          delay_while_idle: delay_while_idle,
          local_only: local_only,
          wearable: wearable,
          interactive: interactive
        })
      end

      # Web Notify specific portion of Push Notification Object
      def web(alert: nil, title: nil, extra: nil, require_interaction: nil, icon: nil)
        compact_helper({
          alert: alert,
          title: title,
          extra: extra,
          require_interaction: require_interaction,
          icon: icon
        })
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

      # Open Platform specific portion of Push Notification Object.
      def open_platform(alert: nil, title: nil, summary: nil,
                        extra: nil, media_attachment: nil, interactive: nil)
        compact_helper({
          alert: alert,
          title: title,
          summary: summary,
          extra: extra,
          media_attachment: media_attachment,
          interactive: interactive
        })
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

      # In-app message specific portion of Push Notification Object
      def in_app(alert: nil, display_type: nil, display: nil, expiry: nil,
                 actions: nil, interactive: nil, extra: nil)
        compact_helper({
          alert: alert,
          display_type: display_type,
          display: display,
          expiry: expiry,
          actions: actions,
          interactive: interactive,
          extra: extra
        })
      end

      # Interactive Notification portion of Push Notification Object
      def interactive(type: required('type'), button_actions: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?
        compact_helper({ type: type, button_actions: button_actions })
      end

      #SMS specific portion of Push Notification Object
      def sms(alert: nil, expiry:nil)
        compact_helper({
          alert: alert,
          expiry: expiry
          })
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

      # iOS Media Attachment builder
      def media_attachment(url: required('url'), content: nil, options: nil)
        fail ArgumentError, 'url must not be nil' if url.nil?
        compact_helper({
          url: url,
          content: content,
          options: options
        })
      end

      # iOS Content builder. Each argument describes the portions of the
      # notification that should be modified if the media_attachment succeeds.
      def content(title: nil, subtitle: nil, body: nil)
        compact_helper({
          title: title,
          subtitle: subtitle,
          body: body
        })
      end

      # iOS crop builder.
      def crop(x: nil, y: nil, width: nil, height: nil)
        compact_helper({
          x: x,
          y: y,
          width: width,
          height: height
        })
      end

      # Android/Amazon style builder.
      def style(type: required('type'), content: required('content'),
                title: nil, summary: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?

        mapping = {
          big_picture: 'big_picture', big_text: 'big_text', inbox: 'lines'
        }

        compact_helper({
          type: type,
          mapping[type.to_sym] => content,
          title: title,
          summary: summary
        })
      end

      # Android L public notification payload builder.
      def public_notification(title: nil, alert: nil, summary: nil)
        compact_helper({
          title: title,
          alert: alert,
          summary: summary
        })
      end

      # Android wearable payload builder.
      def wearable(background_image: nil, extra_pages: nil, interactive: nil)
        compact_helper({
          background_image: background_image,
          extra_pages: extra_pages,
          interactive: interactive,
        })
      end
    end
  end
end
