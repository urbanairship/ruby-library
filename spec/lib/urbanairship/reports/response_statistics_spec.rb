require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Reports do
  UA = Urbanairship
  airship = UA::Client.new(key: 123, secret: 'abc')

  describe Urbanairship::Reports::IndividualResponseStats do
    expected_response = {
      :body => {
        'push_uuid' => 'f133a7c8-d750-11e1-a6cf-e06995b6c872',
        'direct_responses' => 45,
        'sends' => 123,
        'push_type' => 'UNICAST_PUSH',
        'push_time' => '2012-07-31 12:34:56'
      },
      :code => 200
    }
    ind_stats = UA::IndividualResponseStats.new(client: airship)

    it 'can return an expected response' do
      allow(airship).to receive(:send_request).and_return(expected_response)
      actual_response = ind_stats.get(push_id:'push_id')
      expect(actual_response).to eq(expected_response)
    end

    it 'fails when a nil push_id is included' do
      expect {
        ind_stats.get(push_id: nil)
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::ResponseList do
    item = {
      'push_uuid' => 'ae46a0b4-8130-4fcd-8464-0c601d0390be',
      'sends' =>   0,
      'push_time' => '2015-06-13 23:27:46',
      'push_type' => 'UNICAST_PUSH',
      'direct_responses' => 10,
      'group_id' => 'de4e1149-9dfb-4c29-a639-090b29bada45'
    }
    expected_response = {
      'body' => {
        'pushes' => [item, item, item]
      },
      'code' => 200
    }

    it 'can return an expected response correctly' do
      allow(airship).to receive(:send_request).and_return(expected_response)
      response_list = UA::ResponseList.new(
        client: airship,
        start_date: '2014-06-02',
        end_date: '2015-08-05'
      )
      response_list.each do |resp|
        expect(resp).to eq(item)
      end
    end

    it 'fails when start_date is set to nil' do
      expect {
        UA::ResponseList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/02'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if limit is non-numeric' do
      expect {
        UA::ResponseList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/02',
          limit: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if push_id_start is not a string' do
      expect {
        UA::ResponseList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/02',
          limit: 20,
          push_id_start: 123
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date is not a date' do
      expect {
        UA::ResponseList.new(
          client: airship,
          start_date: 'bad date',
          end_date: '2015/08/02'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if end_date is not a date' do
      expect {
        UA::ResponseList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: 'bad date'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::DevicesReport do
    expected_response = {
      'body' => {
        'total_unique_devices' => 150,
        'date_computed' => '2014-10-01T08:31:54.000Z',
        'date_closed' => '2014-10-01T00:00:00.000Z',
        'counts' => {
          'android' => {
            'unique_devices' => 50,
            'opted_in' => 0,
            'opted_out' => 0,
            'uninstalled' => 10
          },
          'ios' => {
            'unique_devices' => 50,
            'opted_in' => 0,
            'opted_out' => 0,
            'uninstalled' => 10
          },
        }
      },
      'code' => 200
    }

    it 'returns an expected response' do
      allow(airship).to receive(:send_request).and_return(expected_response)
      devices = UA::DevicesReport.new(client: airship).get(date: '2015/08/01')
      expect(devices).to eq(expected_response)
    end

    it 'fails when date is nil' do
      expect {
        UA::DevicesReport.new(client: airship).get(date: nil)
      }.to raise_error(ArgumentError)
    end

    it 'fails when date cannot be parsed' do
      expect {
        UA::DevicesReport.new(client: airship).get(date: 'bad date')
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::OptInList do
    item = {
      'android' => 50,
      'date' => '2012-12-01 00:00:00',
      'ios' => 23
    }
    expected_response = {
      'body' => {
        'optins' => [item, item, item],
        'next_page' => 'next_url',
      },
      'code' => 200
    }
    expected_followup = {
      'body' => {
        'optins' => [item, item, item],
      },
      'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      opt_in_list = UA::OptInList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      opt_in_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::OptInList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::OptInList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::OptInList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::OptInList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::OptOutList do
    item = {
        'android' => 50,
        'date' => '2012-12-01 00:00:00',
        'ios' => 23
    }
    expected_response = {
        'body' => {
          'optouts' => [item, item, item],
          'next_page' => 'next_url',
        },
        'code' => 200
    }
    expected_followup = {
        'body' => {
          'optouts' => [item, item, item],
        },
        'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      opt_out_list = UA::OptOutList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      opt_out_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::OptOutList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::OptOutList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::OptOutList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::OptOutList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::PushList do
    item = {
      'android' => 50,
      'date' => '2012-12-01 00:00:00',
      'ios' => 23
    }
    expected_response = {
      'body' => {
        'sends' => [item, item, item],
        'next_page' => 'next_url',
      },
      'code' => 200
    }
    expected_followup = {
      'body' => {
        'sends' => [item, item, item],
      },
      'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      push_list = UA::PushList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      push_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::PushList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::PushList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::PushList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::PushList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::ResponseReportList do
    item = {
      'android' => {
        'direct' => 3,
        'influenced' => 5
      },
      'date' => '2012-12-01 00:00:00',
      'ios' => {
        'direct' => 23,
        'influenced' => 21
      }
    }
    expected_response = {
      'body' => {
        'responses' => [item, item, item],
        'next_page' => 'next_url',
      },
      'code' => 200
    }
    expected_followup = {
      'body' => {
        'responses' => [item, item, item],
      },
      'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      response_list = UA::ResponseReportList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      response_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::ResponseReportList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::ResponseReportList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::ResponseReportList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::ResponseReportList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::AppOpensList do
    item = {
      'android' => 50,
      'date' => '2012-12-01 00:00:00',
      'ios' => 23
    }
    expected_response = {
      'body' => {
        'opens' => [item, item, item],
        'next_page' => 'next_url',
      },
      'code' => 200
    }
    expected_followup = {
      'body' => {
        'opens' => [item, item, item],
      },
      'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      app_opens_list = UA::AppOpensList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      app_opens_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::AppOpensList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::AppOpensList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::AppOpensList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::AppOpensList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end

  describe Urbanairship::Reports::TimeInAppList do
    item = {
      'android' => 50,
      'date' => '2012-12-01 00:00:00',
      'ios' => 23
    }
    expected_response = {
      'body' => {
        'timeinapp' => [item, item, item],
        'next_page' => 'next_url',
      },
      'code' => 200
    }
    expected_followup = {
      'body' => {
        'timeinapp' => [item, item, item],
      },
      'code' => 200
    }

    it 'can process a paginated response' do
      allow(airship).to receive(:send_request).and_return(expected_response, expected_followup)
      time_in_app_list = UA::TimeInAppList.new(
        client: airship,
        start_date: '2015/06/01',
        end_date: '2015/08/01',
        precision: 'MONTHLY'
      )
      instantiated_list = Array.new
      time_in_app_list.each do |opt_in|
        instantiated_list.push(opt_in)
        expect(opt_in).to eq(item)
      end
      expect(instantiated_list.count).to eq(6)
    end

    it 'fails if the start_date is set to nil' do
      expect {
        UA::TimeInAppList.new(
          client: airship,
          start_date: nil,
          end_date: '2015/08/01',
          precision: 'MONTHLY'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if the precision is set to nil' do
      expect {
        UA::TimeInAppList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: nil
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if precision not set to expected value' do
      expect {
        UA::TimeInAppList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end

    it 'fails if start_date does not parse correctly' do
      expect {
        UA::TimeInAppList.new(
          client: airship,
          start_date: '2015/06/01',
          end_date: '2015/08/01',
          precision: 'bad'
        )
      }.to raise_error(ArgumentError)
    end
  end
end
