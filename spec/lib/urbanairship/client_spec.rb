require 'spec_helper'
require 'urbanairship/client'

describe Urbanairship::Client do
  UA = Urbanairship

  it 'is instantiated with a "key" and "secret"' do
    ua_client = UA::Client.new(key: '123', secret: 'abc')
    expect(ua_client).not_to be_nil
  end

  it 'uses basic auth' do
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))
    expect(RestClient::Request).to(receive(:execute).with(hash_including({ user: '123', password: 'abc' })))
                               .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc')
    ua_client.send_request(method: 'POST', url: UA::Common::CHANNEL_URL)
  end

  it 'uses bearer auth' do
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))

    expected_headers = {
      'X-UA-Appkey' => '123',
      'Authorization' => 'Bearer test-token'
    }
    expect(RestClient::Request).to(receive(:execute).with(include(headers: include(expected_headers))))
                               .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc', token: 'test-token')
    ua_client.send_request(method: 'POST', url: UA::Common::CHANNEL_URL, auth_type: :bearer)
  end
end
