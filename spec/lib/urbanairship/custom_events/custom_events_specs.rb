require 'spec_helper'
require 'urbanairship'
require 'urbanairship/custom_events/custom_event'
require 'urbanairship/custom_events/payload'

describe Urbanairship::CustomEvents::CustomEvent do
  UA = Urbanairship
  let(:key) { '11111' }
  let(:secret) { '22222' }
  let(:token) { '33333' }
  let(:client) { UA::Client.new(key: key, secret: secret, token: token) }

  describe '#create' do
    subject do
      subject_instance.events = [custom_event]
      subject_instance.create
    end

    let(:subject_instance) { described_class.new(client: client) }
    let(:custom_event) do
      UA.custom_events(
        body: UA.custom_events_body(
          interaction_id: 'https://docs.airship.com/api/ua/#schemas-customeventobject',
          interaction_type: 'url',
          name: name,
          properties: {
            'who' => 'Alf',
            'where' => 'In the garage!',
            'from' => 'Melmac'
          },
          session_id: '8d168d40-bc9b-4359-800c-a546918354ac',
          transaction: 'd768f61f-73ba-495f-9e16-b3b9c3b598b7',
          value: value
        ),
        occurred: occurred,
        user: user
      )
    end
    let(:expected_payload) do
      [{
        body: {
          interaction_id: 'https://docs.airship.com/api/ua/#schemas-customeventobject',
          interaction_type: 'url',
          name: name,
          properties: {
            who: 'Alf',
            where: 'In the garage!',
            from: 'Melmac'
          },
          session_id: '8d168d40-bc9b-4359-800c-a546918354ac',
          transaction: 'd768f61f-73ba-495f-9e16-b3b9c3b598b7',
          value: value
        },
        occurred: occurred.strftime('%Y-%m-%dT%H:%M:%S'),
        user: {
          named_user_id: 'Gordon Shumway'
        }
      }]
    end
    let(:name) { 'crash-lands' }
    let(:occurred) { Time.now }
    let(:user) { UA.custom_events_user(named_user_id: 'Gordon Shumway') }
    let(:value) { 12.3 }

    let(:ua_http_response) do
      {
        "body" => {
          "ok" => true,
          "operationId" => operation_id
        },
        "code" => "200",
        "headers" => {
          "content_type" => "application/vnd.urbanairship+json;version=3",
          "data_attribute" => "named_user",
          "cache_control" => "max-age=0",
          "expires" => "Fri, 21 Oct 2016 17:52:29 GMT",
          "last_modified" => "Fri, 21 Oct 2016 17:52:29 GMT",
          "vary" => "Accept-Encoding, User-Agent",
          "content_encoding" => "gzip",
          "content_length" => "802",
          "date" => "Fri, 21 Oct 2016 17:52:29 GMT",
          "connection" => "keep-alive"
        }
      }
    end
    let(:operation_id) { "feeb22bc-5d4f-4865-bd64-0daf87d1babd" }

    it 'returns the expected response' do
      expect(client)
        .to receive(:send_request)
        .with(
          auth_type: :bearer,
          body: JSON.dump(expected_payload),
          content_type: 'application/json',
          method: 'POST',
          url: UA.custom_events_url
        )
        .and_return(ua_http_response)

      expect(subject.status_code).to eq('200')
      expect(subject.ok).to eq(true)
      expect(subject.operation_id).to eq(operation_id)
    end

    context 'with invalid name' do
      let(:name) { 'A' }

      it 'raises the expected error' do
        expect { subject }.to raise_error(ArgumentError, 'invalid "name": it must follows this pattern /^[a-z0-9_\-]+$/')
      end
    end

    context 'with invalid value' do
      let(:value) { '12.3' }

      it 'raises the expected error' do
        expect { subject }.to raise_error(ArgumentError, 'invalid "value": must be a number')
      end
    end

    context 'user without any identifier' do
      let(:user) { UA.custom_events_user }

      it 'raises the expected error' do
        expect { subject }.to raise_error(ArgumentError, 'at least one user identifier must be defined')
      end
    end
  end
end
