require 'spec_helper'

require 'urbanairship/push/push'
require 'urbanairship/push/payload'

include Urbanairship::Push
include Urbanairship::Push::Payload

describe Push do
  it 'can build a full payload structure' do
    p = Push.new(nil)
    p.audience = all_
    p.notification = notification(alert: 'Hello')
    p.options = options(expiry: 10080)
    p.device_types = all_
    p.message = message(
      title: 'Title',
      body: 'Body',
      content_type: 'text/html',
      content_encoding: 'utf8',
      extra: { more: 'stuff' },
      expiry: 10080,
      icons: { list_icon: 'http://cdn.example.com/message.png' },
      options: { some_delivery_option: true }
    )

    expect(p.payload).to eq({
      audience: 'all',
      notification: {alert: 'Hello'},
      device_types: 'all',
      options: { expiry: 10080 },
      message: {
        title: 'Title',
        body: 'Body',
        content_type: 'text/html',
        content_encoding: 'utf8',
        extra: {more: 'stuff'},
        expiry: 10080,
        icons: { list_icon: 'http://cdn.example.com/message.png' },
        options: { some_delivery_option: true },
      }}
    )
  end
end
