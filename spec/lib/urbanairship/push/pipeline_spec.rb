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

    it 'creates a correct immediate trigger with tag added' do
      expected_trigger = { 'tag_added' => { 'tag' => 'tag1', 'group' => 'group1' }}
      actual_trigger = UA.immediate_trigger(type: 'tag_added', tag: 'tag1', group: 'group1')
      expect(expected_trigger).to eq(actual_trigger)
    end

    it 'creates a correct immediate trigger with first open' do
      expected_trigger = 'first_open'
      actual_trigger = UA.immediate_trigger(type: 'first_open')
      expect(expected_trigger).to eq(actual_trigger)
    end
  end

  describe '#historical_trigger' do
    it 'fails when days is not numerical' do
      expect {
        UA.historical_trigger(days: 'bad value')
      }.to raise_error(ArgumentError)
    end

    it 'fails when equals is not boolean' do
      expect {
        UA.historical_trigger(equals: 'bad value', days: 1)
      }.to raise_error(ArgumentError)
    end

    it 'fails when type is not set to open' do
      expect {
        UA.historical_trigger(type: 'bad value', days: 1)
      }.to raise_error(ArgumentError)
    end

    it 'creates a correct historical trigger' do
      expected_trigger = { 'event' => 'open', 'equals' => 0, 'days' => 1 }
      actual_trigger = UA.historical_trigger(type: 'open', equals: false, days: 1)
      expect(expected_trigger).to eq(actual_trigger)
    end
  end

  describe '#tag_condition' do
    it 'fails when tag is set to nil' do
      expect {
        UA.tag_condition(tag: nil)
      }.to raise_error(ArgumentError)
    end

    it 'fails when negated is not set to a boolean' do
      expect {
        UA.tag_condition(tag: 'tag', negated: 'bad value')
      }.to raise_error(ArgumentError)
    end

    it 'sets the tag_condition correctly' do
      expected_condition = { 'tag' => { 'tag_name' => 'tag', 'negated' => false }}
      actual_condition = UA.tag_condition(tag: 'tag')
      expect(actual_condition).to eq(expected_condition)
    end
  end

  describe '#or_condition' do
    it 'sets the or_condition correctly' do
      expected_or_condition = { :or => [{ 'tag' => { 'tag_name' => 'tag', 'negated' => false }}]}
      condition = UA.tag_condition(tag: 'tag')
      actual_or_condition = UA.or(condition)
      expect(actual_or_condition).to eq(expected_or_condition)
    end

    it 'sets the or_condition correctly with an array' do
      expected_or_condition = {
          :or => [
              { 'tag' => { 'tag_name' => 'tag', 'negated' => false }},
              { 'tag' => { 'tag_name' => 'tag2', 'negated' => false }}
          ]
      }
      actual_or_condition = UA.or(UA.tag_condition(tag: 'tag'), UA.tag_condition(tag: 'tag2'))
      expect(actual_or_condition).to eq(expected_or_condition)
    end
  end

  describe '#and_condition' do
    it 'sets the and_condition correctly' do
      expected_and_condition = { :and => [{ 'tag' => { 'tag_name' => 'tag', 'negated' => false }}]}
      condition = UA.tag_condition(tag: 'tag')
      actual_and_condition = UA.and(condition)
      expect(actual_and_condition).to eq(expected_and_condition)
    end

    it 'sets the and_condition correctly with an array' do
      expected_and_condition = {
          :and => [
              { 'tag' => { 'tag_name' => 'tag', 'negated' => false }},
              { 'tag' => { 'tag_name' => 'tag2', 'negated' => false }}
          ]
      }
      actual_and_condition = UA.and(UA.tag_condition(tag: 'tag'), UA.tag_condition(tag: 'tag2'))
      expect(actual_and_condition).to eq(expected_and_condition)
    end
  end

  describe '#pipeline' do
    it 'fails when enabled is not a boolean' do
      expect {
        UA.pipeline(enabled: 'bad value', outcome: 'outcome')
      }.to raise_error(ArgumentError)
    end

    it 'creates correct pipeline' do
      expected_pipeline = {
        'enabled' => true,
        'name' => 'pipeline_name',
        'outcome' => {
          'push' => {
            :audience => 'triggered',
            :notification => { 'alert' => 'hello world' },
            :device_types => 'all'
          }
        },
        'immediate_trigger' => {
          'tag_added' => { 'tag' => 'tag', 'group' => 'tag_group' }
        },
        'constraint' => { 'rate' => { 'pushes' => 10, 'days' => 1 }},
        'condition' => {
          :or => [{ 'tag' => { 'tag_name' => 'tag', 'negated' => false }}]
        }
      }
      push = airship.create_push
      push.audience = 'triggered'
      push.device_types = UA.all
      push.notification = { 'alert' => 'hello world' }
      imm_trigger = UA.immediate_trigger(type: 'tag_added', tag: 'tag', group: 'tag_group')
      actual_pipeline = UA.pipeline(
          name: 'pipeline_name',
          enabled: true,
          outcome: UA.outcome(push: push),
          constraint: UA.rate_constraint(pushes: 10, days: 1),
          condition: UA.or(UA.tag_condition(tag: 'tag')),
          immediate_trigger: imm_trigger)
      expect(actual_pipeline).to eq(expected_pipeline)
    end
  end
end
