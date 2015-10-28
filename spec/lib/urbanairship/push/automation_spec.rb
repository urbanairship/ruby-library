require 'spec_helper'
require 'urbanairship'


describe Urbanairship do
  describe Urbanairship::Push do
    describe Urbanairship::Push::AutomatedMessage do
      UA = Urbanairship
      airship = UA::Client.new(key: '123', secret: 'abc')
      auto_message = UA::AutomatedMessage.new(client: airship)
      push = airship.create_push
      push.audience = 'triggered'
      push.device_types = UA.all
      push.notification = { 'alert' => 'hello world' }
      imm_trigger = UA.immediate_trigger(type: 'tag_added', tag: 'tag', group: 'tag_group')
      pipeline = UA.pipeline(
          name: 'pipeline_name',
          enabled: true,
          outcome: UA.outcome(push: push),
          constraint: UA.rate_constraint(pushes: 10, days: 1),
          condition: UA.or(UA.tag_condition(tag: 'tag')),
          immediate_trigger: imm_trigger
      )

      describe '#create' do
        it 'can create an automated message correctly' do
          expected_response = {
            'ok' => true,
            'operation_id' => 'operation_id',
            'pipeline_urls' => ['pipeline_url']
          }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.create(pipelines: pipeline)
          expect(actual_response).to eq(expected_response)
        end
      end

      describe '#validate' do
        it 'can successfully validate a pipeline' do
          expected_response = { 'body' => { 'ok' => true}, 'code' => 200 }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.validate(pipelines: pipeline)
          expect(actual_response).to eq(expected_response)
        end
      end

      describe '#list_existing' do
        it 'can successfully list existing pipelines' do
          expected_response = {
            'body' => {
              'ok' => true,
              'pipelines' => [
                {
                  'creation_time' => '2015-03-20T18:37:23',
                  'enabled' => true,
                  'immediate_trigger' => {
                    'tag_added' => {'tag' => 'bought_shoes'}
                  },
                  'last_modified_time' => '2015-03-20T19 =>35:12',
                  'name' => 'Shoe buyers',
                  'outcome' => {
                    'push' => {
                      'audience' => 'triggered',
                      'device_types' => ['android'],
                      'notification' => {'alert' => 'So you like shoes, huh?'}
                    }
                  },
                  'status' => 'live',
                  'uid' => '3987f98s-89s3-cx98-8z89-89adjkl29zds',
                  'url' => 'https =>//go.urbanairship.com/api/pipelines/3987f98s-89s3-cx98-8z89-89adjkl29zds'
                },
              ]
            },
            'code' => 200
          }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.list_existing
          expect(actual_response).to eq(expected_response)
        end

        it 'fails if limit is not an interger' do
          expect {
            auto_message.list_existing(start: 123)
          }.to raise_error(ArgumentError)
        end

        it 'fails if enabled is not a boolean' do
          expect {
            auto_message.list_existing(enabled: 'bad value')
          }.to raise_error(ArgumentError)
        end

        it 'sets the correct url when limit is included' do
          allow(airship).to receive(:send_request).and_return('')
          auto_message.list_existing(limit: 10)
          expect(auto_message.url).to eq('https://go.urbanairship.com/api/pipelines/?limit=10')
        end

        it 'sets the correct url when limit and enabled are included' do
          allow(airship).to receive(:send_request).and_return('')
          auto_message.list_existing(limit: 10, enabled: true)
          expect(auto_message.url).to eq('https://go.urbanairship.com/api/pipelines/?limit=10&enabled=true')
        end

        it 'sets the correct url when enabled is included' do
          allow(airship).to receive(:send_request).and_return('')
          auto_message.list_existing(enabled: true)
          expect(auto_message.url).to eq('https://go.urbanairship.com/api/pipelines/?enabled=true')
        end
      end

      describe '#list_deleted' do
        it 'fails when a bad start date is included' do
          expect {
            auto_message.list_deleted(start: 'bad date')
          }.to raise_error(ArgumentError)
        end

        it 'sets the correct url when start is included' do
          allow(airship).to receive(:send_request).and_return('')
          auto_message.list_deleted(start: '2015-08-01')
          expect(auto_message.url).to eq('https://go.urbanairship.com/api/pipelines/deleted/?start=2015-08-01T00:00:00-07:00')
        end

        it 'can successfully list deleted pipelines' do
          expected_response = {
            'body' => {
              'ok' => true,
              'pipelines' => [
                {
                  'deletion_time' => '2015-08-01',
                  'pipeline_id' => 'abc'
                },
                {
                  'deletion_time' => '2015-08-01',
                  'pipeline_id' => 'cba'
                }
              ]
            },
            'code' => 200
          }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.list_deleted(start: '2015-08-01')
          expect(expected_response).to eq(actual_response)
        end
      end

      describe '#lookup' do
        it 'can successfully retrieve pipeline info' do
          expected_response = {
            'ok' => true,
            'pipeline' => {
              'creation_time' => '2015-02-14T19 =>19:19',
              'enabled' => true,
              'immediate_trigger' => { 'tag_added' => 'new_customer'},
              'last_modified_time' => '2015-03-01T12:12:54',
              'name' => 'New customer',
              'outcome' => {
                'push' => {
                  'audience' => 'triggered',
                  'device_types' => 'all',
                  'notification' => { 'alert' => 'Hello new customer!'}
                }
              },
              'status' => 'live',
              'uid' => '86ad9239-373d-d0a5-d5d8-04fed18f79bc',
              'url' => 'https =>//go.urbanairship/api/pipelines/86ad9239-373d-d0a5-d5d8-04fed18f79bc'
            }
          }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.lookup(pipeline_id: 'abc')
          expect(expected_response).to eq(actual_response)
        end

        it 'fails when pipeline_id is not a string' do
          expect {
            auto_message.lookup(pipeline_id: 123)
          }.to raise_error(ArgumentError)
        end
      end

      describe '#update' do
        it 'can successfully update a pipeline' do
          expected_response = { 'body' => { 'ok' => true }, 'code' => 200 }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.update(pipeline_id: 'abc', pipeline: pipeline)
          expect(actual_response).to eq(expected_response)
        end

        it 'fails when pipeline_id is not a string' do
          expect {
            auto_message.update(pipeline_id: 123, pipeline: pipeline)
          }.to raise_error(ArgumentError)
        end
      end

      describe '#delete' do
        it 'can successfully delete a pipeline' do
          expected_response = { 'body' => {}, 'code' => 204 }
          allow(airship).to receive(:send_request).and_return(expected_response)
          actual_response = auto_message.delete(pipeline_id: 'abc')
          expect(actual_response).to eq(expected_response)
        end

        it 'fails when pipeline_id is not a string' do
          expect {
            auto_message.delete(pipeline_id: 123)
          }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
