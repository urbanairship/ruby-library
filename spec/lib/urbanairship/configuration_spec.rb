require 'spec_helper'
require 'logger'
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

  describe '#log_level' do
    it 'initializes with the original value "debug level"' do
      expect(config.log_level).to eq(Logger::DEBUG)
    end

    it 'sets the level as is informed' do
      expect { config.log_level = Logger::INFO }.to change(config, :log_level).from(Logger::DEBUG).to(Logger::INFO)
    end
  end
end
