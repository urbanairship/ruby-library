require 'spec_helper'

require 'urbanairship/push/payload'
include Urbanairship::Push::Payload

describe Urbanairship do
  describe '#notification' do
    it 'builds a simple alert' do
      expect(notification(alert: 'Hello')).to eq({ alert: 'Hello' })
    end
  end
end
