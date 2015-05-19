require 'spec_helper'

require 'urbanairship'

describe Urbanairship do
  UA = Urbanairship

  let(:a_time) { DateTime.new(2013, 1, 1, 12, 56) }
  let(:a_time_in_text) { '2013-01-01T12:56:00' }

  describe '#scheduled_time' do
    it 'creates a payload from a DateTime' do
      payload = UA.scheduled_time(a_time)
      expect(payload).to eq(scheduled_time: a_time_in_text)
    end
  end

  describe '#local_scheduled_time' do
    it 'creates a payload from a DateTime' do
      payload = UA.local_scheduled_time(a_time)
      expect(payload).to eq(local_scheduled_time: a_time_in_text)
    end
  end
end
