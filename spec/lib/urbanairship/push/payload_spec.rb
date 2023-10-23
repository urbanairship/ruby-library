require 'spec_helper'
require 'urbanairship'


describe Urbanairship do
  UA = Urbanairship

  describe '#interactive' do
    it 'must be given a "type"' do
      expect {
        UA.interactive(type: nil)
      }.to raise_error ArgumentError
    end

    it 'does not require button actions' do
      expect(UA.interactive(type: 't')).to eq type: 't'
    end
  end

  describe '#options' do
    it 'accepts an integer expiry' do
      expect(UA.options(expiry: 12_000)).to eq(expiry: 12_000)
    end

    it 'accepts a string date' do
      date = '2015-04-01T12:00:00'
      expect(UA.options(expiry: date)).to eq(expiry: date)
    end

    it 'tests options parameters' do
      expect(UA.options(bypass_frequency_limits: true)).to eq(bypass_frequency_limits: true)
      expect(UA.options(bypass_holdout_groups: true)).to eq(bypass_holdout_groups: true)
      expect(UA.options(no_throttle: true)).to eq(no_throttle: true)
      expect(UA.options(omit_from_activity_log: true)).to eq(omit_from_activity_log: true)
      expect(UA.options(personalization: true)).to eq(personalization: true)
      expect(UA.options(redact_payload: true)).to eq(redact_payload: true)
      multiple_options = {
          expiry: '2023-04-01T12:00:00',
          bypass_frequency_limits: true,
          bypass_holdout_groups: false,
          no_throttle: true,
          omit_from_activity_log: false,
          personalization: true,
          redact_payload: false
      }
      expect(UA.options(**multiple_options)).to eq(multiple_options)
    end
  end


  describe '#notification' do
    it 'builds a simple text alert' do
      expect(UA.notification(alert: 'Hello')).to eq alert: 'Hello'
    end

    it 'requires a parameter' do
      expect {
        UA.notification
      }.to raise_error ArgumentError
    end

    context 'Android' do
      it 'builds a notification' do
        payload = UA.notification(android: UA.android(
          alert: 'Hello',
          title: 'My title',
          summary: 'My summary',
          icon: 'icon',
          icon_color: '#111111',
          notification_tag: 'tag',
          category: 'alarm',
          visibility: 1,
          sound: 'default',
          priority: 0,
          delay_while_idle: true,
          collapse_key: '123456',
          time_to_live: 100,
          extra: { more: 'stuff' },
          style: {
              type: 'big_picture',
              big_picture: 'http://pic.com/photo'
          },
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }}))
        expect(payload).to eq(android: {
                                alert: 'Hello',
                                title: 'My title',
                                summary: 'My summary',
                                icon: 'icon',
                                icon_color: '#111111',
                                notification_tag: 'tag',
                                category: 'alarm',
                                visibility: 1,
                                sound: 'default',
                                priority: 0,
                                delay_while_idle: true,
                                collapse_key: '123456',
                                time_to_live: 100,
                                extra: { more: 'stuff' },
                                style: {
                                    type: 'big_picture',
                                    big_picture: 'http://pic.com/photo'
                                },
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
                                }
                              })
      end

      it 'builds a style object' do
        message = UA.notification(android: UA.android(style: {
            type: 'big_picture',
            content: 'http://pic.com/photo',
            summary: 'the subtext'
        }))
        expect(message).to eq android: { 'style': {
            type: 'big_picture',
            content: 'http://pic.com/photo',
            summary: 'the subtext'
        }}
      end

      it 'builds a public notification' do
        message = UA.notification(android: UA.android(public_notification: {
            title: 'the title',
            alert: 'hello, there',
            summary: 'the subtext'
        }))
        expect(message).to eq android: { 'public_notification': {
            title: 'the title',
            alert: 'hello, there',
            summary: 'the subtext'
        }}
      end

      it 'builds a wearable object' do
        message = UA.notification(android: UA.android(wearable: {
            background_image: 'http://example.com/background.png',
            extra_pages: [
                {
                    title: 'Page 1 title - optional title',
                    alert: 'Page 1 title - optional alert'
                },
                {
                    title: 'Page 2 title - optional title',
                    alert: 'Page 2 title - optional alert'
                }
            ],
            interactive: {
                type: 'a_type',
                button_actions: {
                    yes: { add_tag: 'clicked_yes' },
                    no: { add_tag: 'clicked_no' }
                }
            }
        }))
        expect(message).to eq android: { 'wearable': {
            background_image: 'http://example.com/background.png',
            extra_pages: [
                {
                    title: 'Page 1 title - optional title',
                    alert: 'Page 1 title - optional alert'
                },
                {
                    title: 'Page 2 title - optional title',
                    alert: 'Page 2 title - optional alert'
                }
            ],
            interactive: {
                type: 'a_type',
                button_actions: {
                    yes: { add_tag: 'clicked_yes' },
                    no: { add_tag: 'clicked_no' }
                }
            }
          }}
      end
    end


    context 'iOS' do
      it 'builds a notification' do
        payload = UA.notification(ios: UA.ios(
          alert: 'Hello',
          badge: '+1',
          sound: 'cat.caf',
          extra: { more: 'stuff' },
          expiry: 'time',
          category: 'test',
          priority: 5,
          thread_id: "test",
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }
          },
          live_activity: UA.live_activity(
            name: "Test", 
            event: "update")))
        expect(payload).to eq(ios: {
                                alert: 'Hello',
                                badge: '+1',
                                sound: 'cat.caf',
                                extra: { more: 'stuff' },
                                expiry: 'time',
                                category: 'test',
                                priority: 5,
                                thread_id: "test",
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
                                },
                                live_activity: {
                                  name: "Test",
                                  event: "update"
                                }
                              })
      end

      it 'builds a notification with a key/value alert' do
        payload = UA.notification(ios: UA.ios(
          alert: { foo: 'bar' },
          badge: '+1',
          sound: 'cat.caf',
          extra: { more: 'stuff' },
          expiry: 'time',
          priority: 10,
          category: 'test',
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }
          },
          media_attachment: {
              url: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif'
          },
          title: 'iOS title',
          subtitle: 'iOS subtitle',
          collapse_id: 'test'))
        expect(payload).to eq(ios: {
                                alert: { foo: 'bar' },
                                badge: '+1',
                                sound: 'cat.caf',
                                extra: { more: 'stuff' },
                                expiry: 'time',
                                priority: 10,
                                category: 'test',
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
                                },
                                media_attachment: {
                                    url: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif'
                                },
                                title: 'iOS title',
                                subtitle: 'iOS subtitle',
                                collapse_id: 'test'
                              })
      end

      it 'builds a media attachment' do
        message = UA.notification(ios: UA.ios(media_attachment: {
            url: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif',
            title: "title",
            body: 'body',
            options: {
              crop: UA.crop(
                height: 0.5,
                width: 0.5
                ),
              time: 15
            }
        }))
        expect(message).to eq ios: { 'media_attachment': {
            url: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif',
            title: "title",
            body: 'body',
            options: {
              crop: UA.crop(
                height: 0.5,
                width: 0.5
                ),
              time: 15
            }
        }}
      end

      it 'can handle Unicode' do
        message = UA.notification(ios: UA.ios(alert: 'Paß auf!'))
        expect(message).to eq ios: { alert: 'Paß auf!' }
      end

      it 'handles the "content-available" attribute properly' do
        message = UA.notification(ios: UA.ios(content_available: true))
        expect(message).to eq ios: { 'content-available' => true }
      end

      it 'handles the "mutable-content" attribute properly' do
        message = UA.notification(ios: UA.ios(mutable_content: true))
        expect(message).to eq ios: { 'mutable-content' => true }
      end
    end

    context 'Amazon' do
      it 'builds a notification' do
        payload = UA.notification(amazon: UA.amazon(
          alert: 'Hello',
          title: 'My Title',
          consolidation_key: '123456',
          expires_after: 100,
          summary: 'Summary of the message',
          extra: { more: 'stuff' },
          interactive:{
             type:'a_type',
             button_actions:{
                yes:{
                   add_tag:'clicked_yes'
                },
                no:{
                   add_tag:'clicked_no'
                }
             }
          },
          style: {
            big_picture: 'http://pic.com/photo',
            big_text: 'This is big text.'
          },
          sound: 'default'))
        expect(payload).to eq(amazon: {
                                alert: 'Hello',
                                title: 'My Title',
                                consolidation_key: '123456',
                                expires_after: 100,
                                summary: 'Summary of the message',
                                extra: { more: 'stuff' },
                                interactive:{
                                   type:'a_type',
                                   button_actions:{
                                      yes:{
                                         add_tag:'clicked_yes'
                                      },
                                      no:{
                                         add_tag:'clicked_no'
                                      }
                                   }
                                },
                                style: {
                                    big_picture: 'http://pic.com/photo',
                                    big_text: 'This is big text.'
                                },
                                sound: 'default'})
      end
    end

    context 'Web' do
      it 'builds a notification' do
        payload = UA.notification(web: UA.web(
          alert: 'Hello',
          title: 'My Title',
          extra: { more: 'stuff' },
          require_interaction: true,
          icon: { url: 'http://www.example.com' }))
        expect(payload).to eq(web: {
                                alert: 'Hello',
                                title: 'My Title',
                                extra: { more: 'stuff' },
                                require_interaction: true,
                                icon: { url: 'http://www.example.com' }})
      end
    end

    context 'Open Platform' do
      it 'builds a notification' do
        payload = UA.notification(
          open_platforms: {'open::toaster':
            UA.open_platform(
              alert: 'Hello Toaster',
              title: 'My Title',
              summary: 'My Summary',
              extra: { more: 'stuff' },
              media_attachment: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif',
              interactive: {
                type: 'a_type',
                button_actions: {
                  yes: { add_tag: 'clicked_yes' },
                  no: { add_tag: 'clicked_no' }
                }
              }
            )
          }
        )
        expect(payload).to eq(
          'open::toaster': {
            alert: 'Hello Toaster',
            title: 'My Title',
            summary: 'My Summary',
            extra: { more: 'stuff' },
            media_attachment: 'https://media.giphy.com/media/JYsWwF82EGnpC/giphy.gif',
            interactive: {
              type: 'a_type',
              button_actions: {
                yes: { add_tag: 'clicked_yes' },
                no: { add_tag: 'clicked_no' }
              }
            }
          }
        )
      end
    end

    context 'WNS' do
      it 'can send a simple text "alert"' do
        payload = UA.notification(wns: UA.wns_payload(alert: 'Hello'))
        expect(payload).to eq wns: { alert: 'Hello' }
      end

      it 'can send a key/value "toast"' do
        payload = UA.notification(wns: UA.wns_payload(toast: { a_key: 'a_value' }))
        expect(payload).to eq wns: { toast: { a_key: 'a_value' } }
      end

      it 'can send a key/value "tile"' do
        payload = UA.notification(wns: UA.wns_payload(tile: { a_key: 'a_value' }))
        expect(payload).to eq wns: { tile: { a_key: 'a_value' } }
      end

      it 'can send a key/value "badge"' do
        payload = UA.notification(wns: UA.wns_payload(badge: { a_key: 'a_value' }))
        expect(payload).to eq wns: { badge: { a_key: 'a_value' } }
      end

      it 'will only send one kind of notification at a time' do
        expect {
          UA.wns_payload(alert: 'Hello', tile: 'Foo')
        }.to raise_error ArgumentError
      end
    end

    context 'Rich Push' do
      it 'can send UTF-8 HTML' do
        payload = UA.message(
          title: 'My Title',
          body: '<html>Körper des Dokumentes</html>',
          content_type: 'text/html',
          content_encoding: 'utf8',
          extra: { more: 'stuff' },
          expiry: 'time'
        )
        expect(payload).to eq(
          title: 'My Title',
          body: '<html>Körper des Dokumentes</html>',
          content_type: 'text/html',
          content_encoding: 'utf8',
          extra: { more: 'stuff' },
          expiry: 'time'
        )
      end

      it 'can send plain text' do
        payload = UA.message(title: 'My Title', body: 'My Body')
        expect(payload).to eq title: 'My Title', body: 'My Body'
      end
    end

    describe '#device_types' do
      it 'supports the "all" option' do
        expect(UA.device_types(UA.all)).to eq 'all'
      end
    end

    context 'In-App Message' do
    it 'builds an in-app text alert' do
      payload = UA.in_app(
        alert: 'Hello',
        display_type: 'banner',
        display: 'top',
        expiry: 0,
        actions: { add_tag: 'in_app' },
        interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }},
        extra: { more: 'stuff' }
      )
      expect(payload).to eq(
        alert: 'Hello',
        display_type: 'banner',
        display: 'top',
        expiry: 0,
        actions: { add_tag: 'in_app' },
        interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }},
        extra: { more: 'stuff' }
      )
      end
    end

    context 'SMS Message' do
      it 'builds an sms notification' do
        payload = UA.sms(
          alert: 'a shorter alert for sms users',
          expiry: '2020-04-01T12:00:00'
        )
        expect(payload).to eq(
          alert: 'a shorter alert for sms users',
          expiry: '2020-04-01T12:00:00'
        )
      end
    end

    context 'Email Message' do
      it 'builds an email notificaiton' do
        payload = UA.email(
          bypass_opt_in_level: false,
          html_body: "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.airship.com/email/success.html\">Unsubscribe</a></p>",
          message_type: "commercial",
          plaintext_body: "Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.airship.com/email/success.html\"]]",
          reply_to: "no-reply@airship.com",
          sender_address: "team@airship.com",
          sender_name: "Airship",
          subject: "Did you get that thing I sent you?"
        )
      end

      it 'fails when message_type is not set' do
        expect {
          UA.email(message_type: nil)
        }.to raise_error ArgumentError
      end

      it 'fails when plaintext_body is not set' do
        expect {
          UA.email(plaintext_body: nil)
        }.to raise_error ArgumentError
      end

      it 'fails when reply_to is not set' do
        expect {
          UA.email(reply_to: nil)
        }.to raise_error ArgumentError
      end

      it 'fails when sender_address is not set' do
        expect {
          UA.email(sender_address: nil)
        }.to raise_error ArgumentError
      end

      it 'fails when sender_name is not set' do
        expect {
          UA.email(sender_name: nil)
        }.to raise_error ArgumentError
      end

      it 'fails when subject is not set' do
        expect {
          UA.email(subject: nil)
        }.to raise_error ArgumentError
      end
    end

  end
end
