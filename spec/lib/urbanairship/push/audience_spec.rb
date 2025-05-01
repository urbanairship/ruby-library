require 'spec_helper'
require 'urbanairship'


describe Urbanairship do
  UA = Urbanairship

  context 'audience selectors' do
    [
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
        :channel,
        '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3',
        { channel: '074e84a2-9ed9-4eee-9ca4-cc597bfdbef3' }
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
        :tag,
        'test',
        { tag: 'test' }
      ],
      [
        :tag,
        'test',
        { tag: 'test' }
      ],
      [
        :tag,
        ['test', { group: 'test-group' }],
        { tag: 'test', group: 'test-group' }
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
      ],
      [
        :named_user,
        'test',
        { named_user: 'test' }
      ]
    ].each do |selector, value, expected_result|
      it "can filter for '#{selector}'" do
        if selector == :tag && value.is_a?(Array) && value[1].is_a?(Hash)
          tag_value, options = value
          actual_payload = UA.send(selector, tag_value, **options)
        else
          actual_payload = UA.send(selector, *value)
        end
        expect(actual_payload).to eq expected_result
      end
    end

    [
      [:ios_channel, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef34'],
      [:android_channel, '074e84a2-9ed9-Beee-9ca4-ccc597bfdbef3'],
      [:amazon_channel, '074e84a2-Red9-5eee-0ca4-cc597bfdbef3'],
      [:channel, '074e84a2-Red9-5eee-0ca4-cc597bfdbef3'],
      [:device_token, 'f' * 63],
      [:device_token, 'f' * 65],
      [:device_token, '0123'],
      [:device_token, 'X' * 64],
      [:apid, 'foobar'],
      [:apid, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef33'],
      [:apid, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef'],
      [:wns, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef']
    ].each do |selector, value|
      it "raise an error if ##{selector}'s parameter is invalid" do
        expect { UA.send(selector, value) }.to raise_error ArgumentError
      end
    end
  end

  context 'compound selectors' do
    it 'can create an OR' do
      result = UA.or({ tag: 'foo' }, tag: 'bar')
      expect(result).to eq(or: [{ tag: 'foo' }, { tag: 'bar' }])
    end

    it 'can create an AND' do
      result = UA.and({ tag: 'foo' }, tag: 'bar')
      expect(result).to eq(and: [{ tag: 'foo' }, { tag: 'bar' }])
    end

    it 'can create a NOT' do
      result = UA.not(tag: 'foo')
      expect(result).to eq(not: { tag: 'foo' })
    end
  end
end