require 'spec_helper'
require 'urbanairship/oauth'

describe Urbanairship::Oauth do
  UA = Urbanairship

  it 'is instantiated with Oauth assertion auth' do
    oauth = UA::Oauth.new(
      client_id: 'hf73hfh_test_client_id_83hrg',
      assertion_private_key: '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----',
      key: '37djhf_test_app_key_ndf8h3'
    )
    expect(oauth).not_to be_nil
  end

  it 'requests a token using assertion auth' do
    assertion_jwt = 'test_assertion'
    private_key = '-----BEGIN PRIVATE KEY-----
MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDAyfZQIiXQwXabABKqV
LWU/Yek+jz/OIdEMK4nvaa77/nNTc6WgzudKityW09PuJIKhZANiAATaKO7pdTRk
NDqMIFjtTILog5pfX+OZkrMr+2i3VoQoiFwzJO0fh0xCJ2Lg1l7nYIOCs09/deb1
fwMOSxoXG/IMD3AqqwqZzRmgeKfnupueqO3RNxngJUL+0zQTW+dSXWk=
-----END PRIVATE KEY-----
'

    oauth = UA::Oauth.new(client_id: 'test123', key: 'testappkey', assertion_private_key: private_key)

    request_params = {
      payload: {
        assertion: assertion_jwt,
        grant_type: "client_credentials"
      }
    }

    allow(oauth).to receive(:build_assertion_jwt).and_return(assertion_jwt)

    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: '{"access_token": "mock_token"}'))
    expect(RestClient::Request).to(receive(:execute).with(hash_including(request_params))).and_return(mock_response)

    token = oauth.get_token
    expect(token).to eq("mock_token")
  end

  it 'builds an assertion jwt' do
    # This is a private key from revoked oauth credentials on a test app.
    # An actual private key is required to test this properly.
    private_key = '-----BEGIN PRIVATE KEY-----
MIG2AgEAMBAGByqGSM49AgEGBSuBBAAiBIGeMIGbAgEBBDAyfZQIiXQwXabABKqV
LWU/Yek+jz/OIdEMK4nvaa77/nNTc6WgzudKityW09PuJIKhZANiAATaKO7pdTRk
NDqMIFjtTILog5pfX+OZkrMr+2i3VoQoiFwzJO0fh0xCJ2Lg1l7nYIOCs09/deb1
fwMOSxoXG/IMD3AqqwqZzRmgeKfnupueqO3RNxngJUL+0zQTW+dSXWk=
-----END PRIVATE KEY-----
'

    oauth = UA::Oauth.new(client_id: 'test123', key: 'testappkey', assertion_private_key: private_key)
    assertion_jwt = oauth.build_assertion_jwt

    expect(assertion_jwt).not_to be_nil
  end

  it 'should retrieve a public key' do
    oauth = UA::Oauth.new(client_id: 'test123', key: 'testappkey', assertion_private_key: 'testsecret')
    key_id = 'test123'
    public_key = 'test_public_key'
    server = 'https://oauth2.asnapius.com/verify/public_key/test123'

    mock_response = double('response')
    allow(mock_response).to(receive_messages(code: 200, headers: '', body: public_key))
    expect(RestClient).to(receive(:get).with(server, {'Host': oauth.oauth_server, 'Accept': 'text/plain'}))
                               .and_return(mock_response)

    public_key = oauth.verify_public_key(key_id)
    expect(public_key).to eq("test_public_key")
  end
end