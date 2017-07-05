require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Loggable do
  describe '#logger' do
    it { expect(subject.logger).to be_an_instance_of(Logger) }
  end

  describe '.logger' do
    it { expect(described_class.logger).to be_an_instance_of(Logger) }
  end

  describe '.create_logger' do
    let(:logger) { described_class.create_logger }

    it { expect(logger).to be_an_instance_of(Logger) }
    it { expect(logger.progname).to eq 'Urbanairship' }
    it { expect(logger.datetime_format).to eq '%Y-%m-%d %H:%M:%S' }

    context 'without ENV vars' do
      it 'initializes with default filename' do
        expect(Logger).to receive(:new).with('urbanairship.log').and_call_original
        logger
      end

      it 'has the log level as INFO' do
        expect(logger.level).to eq(Logger::INFO)
      end
    end

    context 'with ENV vars' do
      before do
        ENV['URBANAIRSHIP_LOG_FILENAME'] = 'urbanairship.test.log'
        ENV['URBANAIRSHIP_LOG_LEVEL'] = 'DEBUG'
      end

      it 'initializes with custom filename' do
        expect(Logger).to receive(:new).with('urbanairship.test.log').and_call_original
        logger
      end

      it 'has the custom log level' do
        expect(logger.level).to eq(Logger::DEBUG)
      end
    end
  end
end
