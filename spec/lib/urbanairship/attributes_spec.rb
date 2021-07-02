require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Attributes do
  let(:key_1) { 'first_name' }
  let(:value_1) { 'Airship' }
  let(:key_2) { 'last_name' }
  let(:value_2) { 'API' }
  let(:timestamp) { Time.now.utc - 3600 }

  let(:attributes) do
    [
      { key: key_1, value: value_1, action: described_class::SET, timestamp: timestamp },
    ]
  end
  let(:expected) do
    {
      attributes: [
        {
          key: key_1,
          value: value_1,
          action: described_class::SET,
          timestamp: timestamp.iso8601,
        },
      ],
    }
  end

  before { Timecop.freeze(Time.now.utc) }
  after { Timecop.return }

  describe 'Payload' do
    let(:payload) { described_class.new(attributes).payload }

    context 'Action type is not set' do
      let(:attributes) do
        [
          { key: key_1, value: value_1, timestamp: timestamp },
        ]
      end

      it 'defaults to `set` action' do
        puts timestamp.iso8601
        expect(payload).to eq expected
      end
    end

    describe 'Set action' do
      it 'defaults to `set` action' do
        expect(payload).to eq expected
      end
    end

    context 'Timestamp not provided' do
      let(:timestamp) { nil }
      let(:expected) do
        {
          attributes: [
            {
              key: key_1,
              value: value_1,
              action: described_class::SET,
              timestamp: Time.now.utc.iso8601,
            },
          ],
        }
      end

      it 'uses expected provided timestamp' do
        expect(payload).to eq expected
      end
    end

    describe 'Remove action' do
      let(:attributes) do
        [
          { key: key_1, action: described_class::REMOVE, timestamp: timestamp }
        ]
      end
      let(:expected) do
        {
          attributes: [
            {
              key: key_1,
              action: described_class::REMOVE,
              timestamp: timestamp.iso8601,
            },
          ],
        }
      end

      it 'generates expected payload' do
        expect(payload).to eq expected
      end
    end

    describe 'Loops over multiple records' do
      let(:attributes) do
        [
          { key: key_1, action: described_class::REMOVE },
          { key: key_2, value: value_2 }
        ]
      end
      let(:expected) do
        {
          attributes: [
            {
              key: key_1,
              action: described_class::REMOVE,
              timestamp: Time.now.utc.iso8601,
            },
            {
              key: key_2,
              value: value_2,
              action: described_class::SET,
              timestamp: Time.now.utc.iso8601,
            },
          ],
        }
      end

      it 'generates expected payload' do
        expect(payload).to eq expected
      end
    end
  end
end
