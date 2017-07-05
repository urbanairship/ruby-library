require 'spec_helper'
require 'urbanairship'

describe Urbanairship do
  describe '.configure' do
    it 'defines the "log_path"' do
      Urbanairship.configure do |config|
        config.log_path = '/tmp'
      end

      expect(Urbanairship.configuration.log_path).to eq('/tmp')
    end
  end
end

