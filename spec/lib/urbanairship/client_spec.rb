require 'spec_helper'
require 'urbanairship/client'

describe Urbanairship::Client do
  UA = Urbanairship

  it 'is instantiated with a "key" and "secret"' do
    ua_client = UA::Client.new(key: '123', secret: 'abc')
    expect(ua_client).not_to be_nil
  end

  it 'lets you override the default server' do
    overriden_server = 'my.custom.server'
    path = '/path-to_paradise'

    mock_response = double('response')
    allow(mock_response).to receive_messages(code: 200, headers: '', body: '{}')

    expect(RestClient::Request)
      .to(receive(:execute)
        .with(hash_including({ url: "https://#{overriden_server}/api#{path}" })))
          .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc', server: overriden_server)
    ua_client.send_request(method: 'POST', path: path)
  end

  it 'lets you specify the url directly' do
    url = 'https://www.airship.com/'
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))

    expect(RestClient::Request)
      .to(receive(:execute)
        .with(hash_including({ url: url })))
          .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc')
    ua_client.send_request(method: 'POST', url: url)
  end

  it 'lets you specify the url with a path' do
    path = '/some-path'
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))

    expect(RestClient::Request)
      .to(receive(:execute)
        .with(hash_including({ url: "https://#{UA.configuration.server}/api#{path}" })))
          .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc')
    ua_client.send_request(method: 'POST', path: path)
  end

  it 'raises an error if both path and url are nil' do
    ua_client = UA::Client.new(key: '123', secret: 'abc')

    expect { ua_client.send_request(method: 'POST') }
      .to raise_error(ArgumentError, "path and url can't be both nil")
  end

  it 'uses basic auth (by default when token not provided)' do
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))
    expect(RestClient::Request).to(receive(:execute).with(hash_including({ user: '123', password: 'abc' })))
                               .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', secret: 'abc')
    ua_client.send_request(method: 'POST', path: UA.channel_path)
  end

  it 'is instantiated with a "key" and "token"' do
    ua_client = UA::Client.new(key: '123', token: 'test-token')
    expect(ua_client).not_to be_nil
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

    ua_client = UA::Client.new(key: '123', token: 'test-token')
    ua_client.send_request(method: 'POST', path: UA.custom_events_path, auth_type: :bearer)
  end

  it 'automatically uses bearer auth when token provided' do
    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{}'))

    expected_headers = {
      'X-UA-Appkey' => '123',
      'Authorization' => 'Bearer test-token'
    }
    expect(RestClient::Request).to(receive(:execute).with(include(headers: include(expected_headers))))
                               .and_return(mock_response)

    ua_client = UA::Client.new(key: '123', token: 'test-token')
    ua_client.send_request(method: 'POST', path: UA.custom_events_path)
  end
end
