require 'spec_helper'
require 'urbanairship'

describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::SubscriptionLists do
    let(:expected_response) do
      {
        body: {
          ok: true
        },
        code: 202,
      }
    end
    let(:list_id) { "some-list" }
    let(:email_addresses) { ["email@example.com"] }

    describe '#update_attributes' do
      let(:payload) do
        {
          subscription_lists: [
             {
                action: "subscribe",
                list_id: list_id
             }
          ],
          audience: {
             email_address: email_addresses
          }
        }
      end

      describe 'Request' do
        it 'makes the expected request' do
          allow(airship).to receive(:send_request) do |arguments|
            expect(arguments).to eq(
              method: 'POST',
              body: payload.to_json,
              path: '/channels/subscription_lists',
              content_type: 'application/json',
            )
            expected_response
          end
          expect(described_class.new(client: airship).subscribe(list_id, email_addresses)).to eq(expected_response)
        end

        it 'fails and raises TypeError list_id is not a String' do
          list_id = nil

          expect{
            described_class.new(client: airship).subscribe(list_id, email_addresses)
          }.to raise_error(TypeError)
        end

        it 'fails and raises TypeError email_addresses is not an Array' do
          email_addresses = nil

          expect{
            described_class.new(client: airship).subscribe(list_id, email_addresses)
          }.to raise_error(TypeError)
        end

        it 'fails and raises TypeError an email address is not a String' do
          email_addresses.push(123)

          expect{
            described_class.new(client: airship).subscribe(list_id, email_addresses)
          }.to raise_error(TypeError)
        end
      end
    end
  end
end
