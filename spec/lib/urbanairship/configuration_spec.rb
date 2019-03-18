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
    it 'initializes with the original value "info level"' do
      expect(config.log_level).to eq(Logger::INFO)
    end

    it 'sets the level as is informed' do
      expect { config.log_level = Logger::WARN }.to change(config, :log_level).from(Logger::INFO).to(Logger::WARN)
    end
  end

  describe '#timeout' do
    it 'initializes with the original value "60"' do
      expect(config.timeout).to eq(60)
    end

    it 'sets the request timeout as is informed' do
      expect { config.timeout = 120 }.to change(config, :timeout).from(60).to(120)
    end
  end
end
