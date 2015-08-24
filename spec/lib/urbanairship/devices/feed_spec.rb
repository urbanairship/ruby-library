require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')
  describe Urbanairship::Devices::Feed do
    feed = Urbanairship::Feed.new(client: airship)
    push = airship.create_push
    push.audience = UA.all
    push.device_types = UA.all
    push.notification = UA.notification(alert: 'hello')

    expected_resp = {
      'body' => {
        'url' => 'url',
        'id' => 'feed_id',
        'last_checked' => nil,
        'feed_url' => 'feed url',
        'template' => {
           'audience' => 'all',
           'device_types' => ['ios', 'android'],
           'notification' => {
             'alert' => 'check this out!',
             'ios' => { 'alert' => 'new item'}
           }
        }
      },
      'code' => 201
    }

    describe '#create' do
      it 'fails when given a non-string url' do
        expect {
          feed.create(url: 123, push: push)
        }.to raise_error(ArgumentError)
      end

      it 'fails when given a non-push-object push parameter' do
        expect {
          feed.create(url: 'url', push: 'bad push')
        }.to raise_error(ArgumentError)
      end

      it 'creates a feed correctly' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_response = feed.create(url: 'url', push: push)
        expect(actual_response).to eq(expected_resp)
      end
    end

    describe '#lookup' do
      it 'fails when feed_id is not a string' do
        expect {
          feed.lookup(feed_id: 123)
        }.to raise_error(ArgumentError)
      end

      it 'looks up info for a feed correctly' do
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_response = feed.lookup(feed_id: 'feed_id')
        expect(actual_response).to eq(expected_resp)
      end
    end

    describe '#update' do
      it 'fails when feed_id is not a string' do
        expect {
          feed.lookup(feed_id: 123, push: push, url: 'url')
        }.to raise_error(ArgumentError)
      end

      it 'fails when push is not a push object' do
        expect {
          feed.lookup(feed_id: 'feed_id', push: 'bad push', url: 'url')
        }.to raise_error(ArgumentError)
      end

      it 'fails when url is not a string' do
        expect {
          feed.lookup(feed_id: 'feed_id', push: push, url: 123)
        }.to raise_error(ArgumentError)
      end

      it 'looks up info on a feed correctly' do
        expected_resp = { 'body' => {}, 'code' => 200 }
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_response = feed.update(feed_id: 'feed_id', push: push, url: 'url')
        expect(actual_response).to eq(expected_resp)
      end
    end

    describe '#delete' do
      it 'fails when feed_id is not a string' do
        expect {
          feed.delete(feed_id: 123)
        }.to raise_error(ArgumentError)
      end

      it 'can delete an individual feed' do
        expected_resp = { 'body' => {}, 'code' => 204 }
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_response = feed.delete(feed_id: 'feed_id')
        expect(actual_response).to eq(expected_resp)
      end
    end
  end
end
