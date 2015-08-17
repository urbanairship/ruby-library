require 'spec_helper'
require 'urbanairship'


describe Urbanairship do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe '#outcome' do
    it 'fails when push is not a push object' do
      expect {
        UA.outcome(push: 'bad push')
      }.to raise_error(ArgumentError)
    end

    it 'fails when the push audience is not set to triggered' do
      p = airship.create_push
      p.audience = 'not_triggered'
      p.notification = UA.notification(alert: 'Hello')
      p.device_types = UA.all
      expect {
        UA.outcome(push: p)
      }.to raise_error(ArgumentError)
    end

    it 'creates a correct outcome with a push' do
      p = airship.create_push
      p.audience = 'triggered'
      p.notification = UA.notification(alert: 'Hello')
      p.device_types = UA.all

      expected_outcome = { 'push' => p.payload }
      actual_outcome = UA.outcome(push: p)
      expect(expected_outcome).to eq(actual_outcome)
    end

    it 'creates a correct outcome with a push and delay' do
      p = airship.create_push
      p.audience = 'triggered'
      p.notification = UA.notification(alert: 'Hello')
      p.device_types = UA.all

      expected_outcome = { 'push' => p.payload, 'delay' => 10 }
      actual_outcome = UA.outcome(push: p, delay: 10)
      expect(expected_outcome).to eq(actual_outcome)
    end
  end

  describe '#rate_constraint' do
    it 'fails when pushes is set to nil' do
      expect {
        UA.rate_constraint(pushes: nil, days: 1)
      }.to raise_error(ArgumentError)
    end

    it 'fails when days is set to nil' do
      expect {
        UA.rate_constraint(pushes: 10, days: nil)
      }. to raise_error(ArgumentError)
    end

    it 'returns a correct constraint' do
      expected_constraint = { 'rate' => { 'pushes' => 10, 'days' => 1 }}
      actual_constraint = UA.rate_constraint(pushes: 10, days: 1)
      expect(expected_constraint). to eq(actual_constraint)
    end
  end

  describe '#immediate_trigger' do
    it 'fails when a non-recognized type is used' do
      expect {
        UA.immediate_trigger(type: 'bad type')
      }.to raise_error(ArgumentError)
    end

    it 'fails when type is tag_added but no tag is specified' do
      expect {
        UA.immediate_trigger(type: 'tag_added')
      }.to raise_error(ArgumentError)
    end

    it 'fails when type is tag_removed but no tag is specified' do
      expect {
        UA.immediate_trigger(type: 'tag_removed')
      }.to raise_error(ArgumentError)
    end

    it 'creates a correct immediate trigger' do
      expected_trigger = { 'tag_added' => { 'tag' => 'tag1', 'group' => 'group1' }}
      actual_trigger = UA.immediate_trigger(type: 'tag_added', tag: 'tag1', group: 'group1')
      expect(expected_trigger).to eq(actual_trigger)
    end
  end
end
