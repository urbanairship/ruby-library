require 'spec_helper'
require 'urbanairship/configuration'

describe Urbanairship::Configuration do
  subject(:config) { described_class.new }

  describe '#log_path' do
    it 'initializes with the original value "nil"' do
      expect(config.log_path).to be_nil
    end

    it 'sets the path as is informed' do
      expect { config.log_path = '/tmp' }.to change(config, :log_path).from(nil).to('/tmp')
    end
  end
end
