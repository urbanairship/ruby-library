require 'spec_helper'
require 'urbanairship/common'


describe Urbanairship::Common do
  it 'has a PUSH_URL' do
    expect(Urbanairship::Common::PUSH_URL).not_to be nil
  end
end
