require 'spec_helper'
require 'urbanairship/common'

describe Urbanairship::Common do
  it 'has a PUSH_URL' do
    expect(Urbanairship::Common::PUSH_URL).not_to be nil
  end
  it 'has a SEGMENTS_URL' do
    expect(Urbanairship::Common::SEGMENTS_URL).not_to be nil
  end
end
