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
        :tag,
        ['test', group: 'test-group'],
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
      ]
    ].each do |selector, value, expected_result|
      it "can filter for '#{selector}'" do
        actual_payload = UA.send(selector, *value)
        expect(actual_payload).to eq expected_result
      end
    end

    [
      [:ios_channel, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef34'],
      [:android_channel, '074e84a2-9ed9-Beee-9ca4-ccc597bfdbef3'],
      [:amazon_channel, '074e84a2-Red9-5eee-0ca4-cc597bfdbef3'],
      [:device_token, 'f' * 63],
      [:device_token, 'f' * 65],
      [:device_token, '0123'],
      [:device_token, 'X' * 64],
      [:device_pin, '1234567'],
      [:device_pin, 'x' * 8],
      [:apid, 'foobar'],
      [:apid, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef33'],
      [:apid, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef'],
      [:wns, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef'],
      [:mpns, '074e84a2-9ed9-4eee-9ca4-cc597bfdbef']
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

  describe '#recent_date' do
    it 'produces a date range in days' do
      expect(UA.recent_date(days: 4)).to eq(recent: { days: 4 })
    end

    it 'produces a date range in hours' do
      expect(UA.recent_date(hours: 4)).to eq(recent: { hours: 4 })
    end

    it 'raises an error if passed multiple key/value pairs' do
      expect {
        UA.recent_date(hours: 1, minutes: 2)
      }.to raise_error ArgumentError
    end

    it 'raises an error if given an invalid resolution' do
      expect {
        UA.recent_date(eons: 7)
      }.to raise_error ArgumentError
    end
  end

  describe '#absolute_date' do
    it 'produces a day-based range' do
      result = UA.absolute_date(resolution: :days,
                             start: '2012-01-01',
                             the_end: '2012-01-05')
      expect(result).to eq(days: { start: '2012-01-01', end: '2012-01-05' })
    end

    it 'produces a week-based range' do
      result = UA.absolute_date(resolution: :weeks,
                             start: '2012-01-01',
                             the_end: '2012-01-05')
      expect(result).to eq(weeks: { start: '2012-01-01', end: '2012-01-05' })
    end

    it 'raises an error if given an invalid resolution' do
      expect {
        UA.absolute_date(resolution: :eons,
                      start: '2012-01-01',
                      the_end: '2012-01-05')
      }.to raise_error ArgumentError
    end
  end

  describe '#location' do
    let(:a_recent_date) {
      { recent: { days: 4 } }
    }

    it 'produces a location based on an id and date' do
      payload = UA.location(id: 'some_id', date: a_recent_date)
      expect(payload).to eq(location: { id: 'some_id', date: a_recent_date })
    end

    it 'produces a location from an alias and date' do
      payload = UA.location(us_zip: '97210', date: a_recent_date)
      expect(payload).to eq(location: { us_zip: '97210', date: a_recent_date })
    end
  end
end
