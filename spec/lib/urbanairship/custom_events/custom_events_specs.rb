require 'spec_helper'
require 'urbanairship'
require 'urbanairship/custom_events/custom_event'
require 'urbanairship/custom_events/payload'

describe Urbanairship::CustomEvents::CustomEvent do
  UA = Urbanairship
  let(:airship) { UA::Client.new(key: '123', secret: 'abc') }

  create_custom_events_response = {
    "ok": "true",
    "operation_id": "feeb22bc-5d4f-4865-bd64-0daf87d1babd"
  }

  describe '#create' do
    subject do
      subject_instance.events = [custom_event]
      subject_instance.create
    end

    let(:subject_instance) { described_class.new(client: airship) }
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
        occurred: occurred.strftime('%Y-%m-%dT%H:%M:%S.%L%z'),
        user: {
          named_user_id: 'Gordon Shumway'
        }
      }]
    end
    let(:name) { 'crash-lands' }
    let(:occurred) { Time.now }
    let(:user) { UA.custom_events_user(named_user_id: 'Gordon Shumway') }
    let(:value) { 12.3 }

    it 'returns the expected response' do
      expect(airship)
        .to receive(:send_request)
        .with(
          method: 'POST',
          body: JSON.dump(expected_payload),
          url: UA.custom_events_url,
          content_type: 'application/json'
        )
        .and_return(create_custom_events_response)

      expect(subject).to eq(create_custom_events_response)
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
