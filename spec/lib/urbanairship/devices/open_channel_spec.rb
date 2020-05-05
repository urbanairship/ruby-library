require 'spec_helper'
require 'urbanairship'


describe Urbanairship::Devices do
  UA = Urbanairship
  airship = UA::Client.new(key: '123', secret: 'abc')

  describe Urbanairship::Devices::OpenChannel do
    expected_resp = {
      'body' => {
        'ok' => true,
        'channel_id' => 'channelid0298379'
      },
      'code'=> 200
    }
    
    expected_lookup_resp = {
      'body' => {
        'ok' => true,
        'channel' => {
          'channel_id' => '123',
          'device_type' => 'open',
          'installed' => true,
          'tags' => ['tag1', 'tag2'],
          'created' => '2017-08-08T20:41:06',
          'address' => '+1 5555555',
          'opt_in' => true,
          'open' => {
            'open_platform_name' => 'sms'
          }
        },
        'last_registration' => '2017-09-01T18:00:27'
      }
    }

    template_id_payload = {
        "open::smart_fridge":{
          'template': {
            'template_id': '12345',
            'fields': {
              'alert': 'Oh hello there!'
            }
          }
        }
      }

    template_id_without_fields = {
        "open::smart_fridge":{
          'template': {
            'template_id': '12345'
          }
        }
      }
    
    expected_update_resp = expected_lookup_resp
    expected_update_resp['body']['tags'] = ['tag3', 'tag4']
    
    describe '#create' do
      it 'creates an open channel' do
        oc = UA::OpenChannel.new(client: airship)
        oc.opt_in = true
        oc.address = '+1 5555555'
        oc.open_platform = 'sms'
        oc.tags = ['tag1', 'tag2']
        
        allow(airship).to receive(:send_request).and_return(expected_resp)
        actual_resp = oc.create()
        expect(actual_resp).to eq(expected_resp)
      end
      
      it 'fails when opt_in is not set' do
        oc_without_opt_in = UA::OpenChannel.new(client: airship)
        oc_without_opt_in.address = '+1 5555555'
        oc_without_opt_in.open_platform = 'sms'
        oc_without_opt_in.tags = ['tag1', 'tag2']
        
        expect{oc_without_opt_in.create()}.to raise_error(TypeError)
      end
      
      it 'fails when address is not set' do
        oc_without_address = UA::OpenChannel.new(client: airship)
        oc_without_address.opt_in = true
        oc_without_address.open_platform = 'sms'
        oc_without_address.tags = ['tag1', 'tag2']
        
        expect{oc_without_address.create()}.to raise_error(TypeError)
      end
      
      it 'fails when open_platform is not set' do
        oc = UA::OpenChannel.new(client: airship)
        oc.opt_in = true
        oc.address = '+1 5555555'
        oc.tags = ['tag1', 'tag2']
        
        expect{oc.create()}.to raise_error(TypeError)
      end
    end
    
    describe'#update' do
      it 'updates tags on an open channel' do
        oc_update = UA::OpenChannel.new(client: airship)
        oc_update.opt_in = true
        oc_update.address = '+1 5555555'
        oc_update.open_platform = 'sms'
        oc_update.tags = ['tag1', 'tag2']
        
        allow(airship).to receive(:send_request).and_return(expected_resp)
        oc_update.create()
        oc_update.tags = ['tag3', 'tag4']
        
        allow(airship).to receive(:send_request).and_return(expected_update_resp)
        actual_resp = oc_update.update(set_tags: true)
        expect(actual_resp).to eq(expected_update_resp)
      end
    end
    
    describe '#lookup' do
      it 'retrieves open channel successfully' do
        oc = UA::OpenChannel.new(client: airship)
        
        allow(airship).to receive(:send_request).and_return(expected_lookup_resp)
        actual_resp = oc.lookup(channel_id: '123')
        expect(actual_resp).to eq(expected_lookup_resp)
      end
      
      it 'fails if channel_id is not provided' do
        oc_without_channel_id = UA::OpenChannel.new(client: airship)
        
        expect{oc_without_channel_id.lookup()}.to raise_error(ArgumentError)
      end
    end

    describe '#notification_with_template_id' do
      it 'formats the proper payload' do
        oc = UA::OpenChannel.new(client: airship)
        oc.open_platform = 'smart_fridge'
        oc.template_id = '12345'
        oc.alert = 'Oh hello there!'
        result = oc.notification_with_template_id
        expect(result).to eq(template_id_payload)
      end

      it 'fails when open platform is nil' do
        oc = UA::OpenChannel.new(client: airship)
        oc.template_id = '12345'
        oc.alert = 'Oh hello there!'
        expect{oc.notification_with_template_id}.to raise_error(TypeError)
      end

      it 'removes fields key if it is blank' do
        oc = UA::OpenChannel.new(client: airship)
        oc.open_platform = 'smart_fridge'
        oc.template_id = '12345'
        result = oc.notification_with_template_id
        expect(result).to eq(template_id_without_fields)
      end
    end

  end
end