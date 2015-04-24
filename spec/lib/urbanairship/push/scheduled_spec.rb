require 'spec_helper'

require 'urbanairship/push/schedule'
include Urbanairship::Push::Schedule


describe Urbanairship do
  let(:a_time) { DateTime.new(2013, 1, 1, 12, 56) }
  let(:a_time_in_text) { '2013-01-01T12:56:00' }

  describe '#scheduled_time' do
    it 'creates a payload from a DateTime' do
      payload = scheduled_time(a_time)
      expect(payload).to eq(scheduled_time: a_time_in_text)
    end
  end

  describe '#local_scheduled_time' do
    it 'creates a payload from a DateTime' do
      payload = local_scheduled_time(a_time)
      expect(payload).to eq(local_scheduled_time: a_time_in_text)
    end
  end
end
