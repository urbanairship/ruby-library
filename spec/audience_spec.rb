require 'spec_helper'

require 'urbanairship/push/audience'
import Urbanairship::Push::Audience

describe Urbanairship do
  context 'selectors' do
    it 'should generate json for the supported selector types' do
      selectors = [
        [
          :ios_channel,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { ios_channel: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :android_channel,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { android_channel: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :amazon_channel,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { amazon_channel: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :device_token,
          'f' * 64,
          { device_token: 'F' * 64 }
        ],
        [
          :device_token,
          '0' * 64,
          { device_token: '0' * 64 }
        ],
        [
          :device_pin,
          '12345678',
          { device_pin: '12345678' }
        ],
        [
          :apid,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { apid: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :wns,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { wns: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :mpns,
          '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
          { mpns: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
        ],
        [
          :tag,
          'test',
          { tag: 'test' }
        ],
        [
          :alias,
          'test',
          { alias: 'test' }
        ],
        [
          :segment,
          'test',
          { segment: 'test' }
        ]
      ]

      selectors.each do |selector, value, expected_result|
        actual = send(selector, value)
        expect(actual).to eq expected_result
      end
    end
  end
end
