require 'spec_helper'

describe Urbanairship::Response do

  before do
    FakeWeb.allow_net_connect = false
  end

  context "#code" do
    subject { Urbanairship.register_device("new_device_token") }

    before do
      FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/new_device_token", :status => ["201", "Created"])
      FakeWeb.register_uri(:put, /bad_key\:my_app_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])
      Urbanairship.application_secret = "my_app_secret"
    end

    it "should be set correctly on new registraion token" do
      Urbanairship.application_key = "my_app_key"
      subject.code.should eql '201'
    end

    it "should set correctly on unauthhorized" do
      Urbanairship.application_key = "bad_key"
      subject.code.should eql '401'
    end
 end

  context "#success?" do
    subject { Urbanairship.register_device("new_device_token") }

    before do
      FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/new_device_token", :status => ["201", "Created"])
      FakeWeb.register_uri(:put, /bad_key\:my_app_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])
      Urbanairship.application_secret = "my_app_secret"
    end

    it "should be true with good key" do
      Urbanairship.application_key = "my_app_key"
      subject.success?.should == true
    end

    it "should be false with bad key" do
      Urbanairship.application_key = "bad_key"
      subject.success?.should == false
    end
  end

  context "#next_page" do
    before :each do
      Urbanairship.application_secret = "my_app_secret"
      Urbanairship.application_key = "my_app_key"
      Urbanairship.master_secret = "my_master_secret"
    end

    describe "api request that is not paginated (doesn't return 'next_page')" do
      describe "a request that returns array" do
        subject { Urbanairship.feedback(Time.now) }

        before do
          FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["200", "OK"], :body => "[{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"},{\"device_token\":\"token2\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}]")
        end

        it "should return nil" do
          subject.next_page.should be_nil    
        end
      end

      describe "a request that returns hash" do
        subject { Urbanairship.device_tokens }

        before do 
          FakeWeb.register_uri(:get, "https://my_app_key:my_master_secret@go.urbanairship.com/api/device_tokens/", :status => ["200", "OK"], :body => '{"device_tokens":[{"device_token": "0101F9929660BAD9FFF31A0B5FA32620FA988507DFFA52BD6C1C1F4783EDA2DB","active": false,"alias": null, "tags": []}], "device_tokens_count":50, "active_device_tokens_count":55}')
        end

        it "should return nil" do
          subject.next_page.should be_nil    
        end
      end
    end

    context "api request that does paginate (have a 'next_page')" do
      before :each do
        FakeWeb.register_uri(:get, "https://my_app_key:my_master_secret@go.urbanairship.com/api/device_tokens/", :status => ["200", "OK"], :body => '{"device_tokens":[{"device_token": "0101F9929660BAD9FFF31A0B5FA32620FA988507DFFA52BD6C1C1F4783EDA2DB","active": false,"alias": null, "tags": []}], "device_tokens_count":50, "active_device_tokens_count":55, "next_page":"https://go.urbanairship.com/api/device_tokens/?limit=1000&start=00xxxyzw-aa88-55dd-b8a7-x1y050888xxy"}')
      end

      subject { Urbanairship.device_tokens }

      describe "response object don't have a valid 'original_request' value" do 

        it "should return nil if 'original_request' doesn't exist" do
          subject.stub(:original_request).and_return(nil)
          subject.next_page.should be_nil              
        end

        it "should return nil if 'original_request' doesn't have a 'ua_client'" do
          subject.stub(:original_request).and_return({})
          subject.next_page.should be_nil                        
        end

        it "should return nil if 'ua_client' is not Urbanairship or Urbanairship::Client" do
          subject.stub(:original_request).and_return({ ua_client: Object.new })
          subject.next_page.should be_nil                        
        end
      end

      describe "with valid ua_client" do
        before :all do
          @body = {"device_tokens" => [ { "device_token" => "AAAAAAAAAAAAA0000000000AAAAAAAAA","active" => true, "tags" => [ 'some_tag' ]}], "device_tokens_count" => 88, "active_device_tokens_count" => 77 }
          FakeWeb.register_uri(:get, "https://my_app_key:my_master_secret@go.urbanairship.com/api/device_tokens/?limit=1000&start=00xxxyzw-aa88-55dd-b8a7-x1y050888xxy", :status => ["200", "OK"], :body => @body.to_json)
        end

        it "should make a call to the next page and return response" do
          subject.next_page.should == @body
        end

        describe "ua_client is Urbanairship::Client" do
          before :all do
            @client = Urbanairship::Client.new
            @client.application_key = 'my_app_key'
            @client.master_secret = 'my_master_secret'
            FakeWeb.register_uri(:get, "https://my_app_key:my_master_secret@go.urbanairship.com/api/device_tokens/", :status => ["200", "OK"], :body => '{"device_tokens":[{"device_token": "0101F9929660BAD9FFF31A0B5FA32620FA988507DFFA52BD6C1C1F4783EDA2DB","active": false,"alias": null, "tags": []}], "device_tokens_count":50, "active_device_tokens_count":55, "next_page":"https://go.urbanairship.com/api/device_tokens/?limit=1000&start=00xxxyzw-aa88-55dd-b8a7-x1y050888xxy"}')
          end

          subject { @client.device_tokens }

          it "should make a call to the next page and return response" do
            subject.next_page.should == @body
          end
        end
      end
    end
  end

  context "body array accessor" do
    subject { Urbanairship.feedback(Time.now) }

    before do
      FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["200", "OK"], :body => "[{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"},{\"device_token\":\"token2\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}]")
      Urbanairship.application_secret = "my_app_secret"
      Urbanairship.application_key = "my_app_key"
      Urbanairship.master_secret = "my_master_secret"
    end

    it "should set up correct indexes" do
      subject[0]['device_token'].should eql "token"
      subject[1]['device_token'].should eql "token2"
    end
  end

  context "non array response" do
    subject { Urbanairship.feedback(Time.now) }

    before do
      FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["200", "OK"], :body => "{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}")
      Urbanairship.application_secret = "my_app_secret"
      Urbanairship.application_key = "my_app_key"
      Urbanairship.master_secret = "my_master_secret"
    end

    it "should set up correct keys" do
      subject['device_token'].should eql "token"
    end
  end
end
