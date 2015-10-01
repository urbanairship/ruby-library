require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Reports do
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Reports::PerPushDetail do
    per_push_details = UA::PerPushDetail.new(client: airship)
    push_details = {
      'app_key' => 'some_app_key',
      'push_id' => '57ef3728-79dc-46b1-a6b9-20081e561f97',
      'created' => '2013-07-25 23:03:12',
      'push_body' => '<Base64-encoded string>',
      'rich_deletions' => 0,
      'rich_responses' => 0,
      'rich_sends' => 0,
      'sends' => 58,
      'direct_responses' => 0,
      'influenced_responses' => 1,
      'platforms' => {
        'android' => {
          'direct_responses' => 0,
          'influenced_responses' => 0,
          'sends' => 22
        },
        'ios' => {
          'direct_responses' => 0,
          'influenced_responses' => 1,
          'sends' => 36
        }
      }
    }

    describe '#get_single' do
      it 'fails when push_id is nil' do
        expect {
          per_push_details.get_single(push_id: nil)
        }.to raise_error(ArgumentError)
      end

      it 'returns push details correctly' do
        expected_response = {
          'body' => push_details,
          'code' => 200
        }
        allow(airship)
          .to receive(:send_request).and_return(expected_response)
        actual_response = per_push_details.get_single(push_id: 'push_id')
        expect(actual_response).to eq(expected_response)
      end
    end

    describe '#get_batch' do
      it 'fails when push_ids are an empty list' do
        expect {
          per_push_details.get_batch(push_ids: [])
        }.to raise_error(ArgumentError)
      end

      it 'returns push details correctly' do
        expected_response = {
          'body' => [ push_details, push_details ],
          'code' => 200
        }
        allow(airship)
          .to receive(:send_request).and_return(expected_response)
        actual_response = per_push_details.get_batch(push_ids: %w(push_id1 push_id2))
        expect(actual_response).to eq(expected_response)
      end
    end
  end

  describe UA::Reports::PerPushSeries do
    describe '#get' do
      push_series = UA::PerPushSeries.new(client: airship)
      series_detail_item = {
        'app_key' => 'ABC123',
        'push_id' => 'CBA321',
        'created' => 0,
        'push_body' => 'ABC',
        'sends' => 57356,
        'direct_responses' => 2654,
        'influenced_responses' => 8915,
        'rich_sends' => 0,
        'rich_responses' => 0,
        'rich_deletions' => 0,
        'platforms' => {
          'ios' => {
            'sends' => 31522,
            'direct_responses' => 1632,
            'influenced_responses' => 5347
          },
          'android' => {
            'sends' => 25834,
            'direct_responses' => 1022,
            'influenced_responses' => 3568
          }
        }
      }
      expected_response = {
        :body => [ series_detail_item, series_detail_item ],
        :code => 200
      }

      it 'fails when push_id is nil' do
        expect {
          push_series.get(push_id: nil)
        }.to raise_error(ArgumentError)
      end

      it 'fails when precision is not valid' do
        expect {
          push_series.get(push_id: 'push_id', precision: 'bad_value')
        }.to raise_error(ArgumentError)
      end

      it 'fails when end is before the start' do
        expect {
          push_series.get(
            push_id: 'push_id',
            precision: 'HOURLY',
            start_date: '2015-08-01 00:00:00',
            end_date: '2015-07-01 00:00:00'
          )
        }.to raise_error(ArgumentError)
      end

      it 'fails when end is equal to start' do
        expect {
          push_series.get(
              push_id: 'push_id',
              precision: 'HOURLY',
              start_date: '2015-08-01 00:00:00',
              end_date: '2015-08-01 00:00:00'
          )
        }.to raise_error(ArgumentError)
      end

      it 'fails when bad date is specified' do
        expect {
          push_series.get(
            push_id: 'push_id',
            precision: 'HOURLY',
            start_date: '2015-08-01 00:00:00',
            end_date: 'bad date'
          )
        }.to raise_error(ArgumentError)
      end

      it 'returns a correct response with push_id only' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = push_series.get(push_id: '123')
        expect(actual_response).to eq(expected_response)
      end

      it 'returns a correct response with precision specified' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = push_series.get(push_id: '123', precision: 'MONTHLY')
        expect(actual_response).to eq(expected_response)
      end

      it 'returns a correct response with precision, start, and end dates specified' do
        allow(airship).to receive(:send_request).and_return(expected_response)
        actual_response = push_series.get(
          push_id: '123',
          precision: 'MONTHLY',
          start_date:'02/08/2015',
          end_date: '03/08/2015'
        )
        expect(actual_response).to eq(expected_response)
      end

      it 'fails when start and end are specified but precision is not' do
        expect {
          push_series.get(
            push_id: 'push_id',
            start_date: '2015-08-01 00:00:00',
            end_date: '2015-08-01 00:00:00'
          )
        }.to raise_error(ArgumentError)
      end
    end
  end
end
