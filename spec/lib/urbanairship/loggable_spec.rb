require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Loggable do
  describe '.logger' do
    before do
      described_class.instance_variable_set(:@logger, nil)
      Urbanairship.configure do |config|
        config.custom_logger = custom_logger
      end
    end

    context 'when there is a custom_logger' do
      let(:custom_logger) { Logger.new(STDOUT) }

      it 'uses the custom_logger' do
        expect(described_class).not_to receive(:create_logger)
        expect(described_class.logger).to eq(Urbanairship.configuration.custom_logger)
      end
    end

    context 'when there is no custom_logger' do
      let(:custom_logger) { nil }

      it 'uses the default lib logger' do
        expect(described_class).to receive(:create_logger).and_call_original
        expect(described_class.logger.instance_variable_get(:@logdev).filename).to eq('urbanairship.log')
      end
    end
  end

  describe '.create_logger' do
    subject(:logger) { described_class.create_logger }

    it 'defines the "datetime_format"' do
      expect(logger.datetime_format).to eq('%Y-%m-%d %H:%M:%S')
    end

    it 'defines the "progname"' do
      expect(logger.progname).to eq('Urbanairship')
    end

    context 'when no log path is informed' do
      it 'defines the log file with only filename' do
        expect(logger.instance_variable_get(:@logdev).filename).to eq('urbanairship.log')
      end
    end

    context 'when a log path is informed' do
      before do
        Urbanairship.configure do |config|
          config.log_path = '/tmp'
        end
      end

      it 'defines the log file with the log path' do
        expect(logger.instance_variable_get(:@logdev).filename).to eq('/tmp/urbanairship.log')
      end
    end

    context 'when no log level is informed' do
      it 'defines the log level with the default logger log level' do
        expect(logger.level).to eq(Logger::INFO)
      end
    end

    context 'when a log path is informed' do
      before do
        Urbanairship.configure do |config|
          config.log_level = Logger::WARN
        end
      end

      it 'defines the log level with the passed value' do
        expect(logger.level).to eq(Logger::WARN)
      end
    end
  end
end
