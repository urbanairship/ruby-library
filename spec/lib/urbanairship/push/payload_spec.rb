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
          delay_while_idle: true,
          collapse_key: '123456',
          time_to_live: 100,
          extra: { more: 'stuff' },
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            } }))
        expect(payload).to eq(android: {
                                alert: 'Hello',
                                delay_while_idle: true,
                                collapse_key: '123456',
                                time_to_live: 100,
                                extra: { more: 'stuff' },
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
                                }
                              })
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
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }
          }))
        expect(payload).to eq(ios: {
                                alert: 'Hello',
                                badge: '+1',
                                sound: 'cat.caf',
                                extra: { more: 'stuff' },
                                expiry: 'time',
                                category: 'test',
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
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
          category: 'test',
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            }
          }))
        expect(payload).to eq(ios: {
                                alert: { foo: 'bar' },
                                badge: '+1',
                                sound: 'cat.caf',
                                extra: { more: 'stuff' },
                                expiry: 'time',
                                category: 'test',
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  }
                                }
                              })
      end

      it 'can handle Unicode' do
        message = UA.notification(ios: UA.ios(alert: 'Paß auf!'))
        expect(message).to eq ios: { alert: 'Paß auf!' }
      end

      it 'handles the "content-available" attribute properly' do
        message = UA.notification(ios: UA.ios(content_available: true))
        expect(message).to eq ios: { 'content-available' => true }
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
          interactive: {
            type: 'a_type',
            button_actions: {
              yes: { add_tag: 'clicked_yes' },
              no: { add_tag: 'clicked_no' }
            } }))
        expect(payload).to eq(amazon: {
                                alert: 'Hello',
                                title: 'My Title',
                                consolidation_key: '123456',
                                expires_after: 100,
                                summary: 'Summary of the message',
                                extra: { more: 'stuff' },
                                interactive: {
                                  type: 'a_type',
                                  button_actions: {
                                    yes: { add_tag: 'clicked_yes' },
                                    no: { add_tag: 'clicked_no' }
                                  } } })
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

  end
end
