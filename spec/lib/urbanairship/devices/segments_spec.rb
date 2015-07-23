require 'spec_helper'

require 'urbanairship'
require 'urbanairship/client'
require 'urbanairship/devices/segment'


describe Urbanairship::Devices do
  UA = Urbanairship

  describe Urbanairship::Devices::Segment do
    test_name = 'Test Segment'
    test_criteria = {
      'and' => [
        { 'tag' => 'TEST' },
        { 'not': {'tag': 'TEST2' }
      ]
    }


    describe '#create' do
      it 'can create a segment' do
      end
    end

    describe '#from_id' do
      it 'can lookup a segment from an id' do
      end
    end

    describe '#update' do
      it 'can update a segment' do
      end
    end

    describe '#delete' do
      it 'can delete a segment' do
      end
    end
  end
end
