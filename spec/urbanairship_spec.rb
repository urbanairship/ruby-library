require 'spec_helper'

shared_examples_for "an Urbanairship client" do
  before(:all) do
    FakeWeb.allow_net_connect = false

    # register_device
    FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/apids/new_device_token", :status => ["201", "Created"])
    FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/new_device_token", :status => ["201", "Created"])
    FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/existing_device_token", :status => ["200", "OK"])
    FakeWeb.register_uri(:put, "https://my_app_key:my_app_secret@go.urbanairship.com/api/device_tokens/device_token_one", :status => ["201", "Created"])
    FakeWeb.register_uri(:put, /bad_key\:my_app_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])

    # unregister_device
    FakeWeb.register_uri(:delete, /my_app_key\:my_app_secret\@go\.urbanairship.com\/api\/apids\/.+/, :status => ["204", "No Content"])
    FakeWeb.register_uri(:delete, /my_app_key\:my_app_secret\@go\.urbanairship.com\/api\/device_tokens\/.+/, :status => ["204", "No Content"])
    FakeWeb.register_uri(:delete, /bad_key\:my_app_secret\@go\.urbanairship.com\/api\/device_tokens\/.+/, :status => ["401", "Unauthorized"])

    # device_info
    FakeWeb.register_uri(:get, /my_app_key\:my_app_secret\@go\.urbanairship.com\/api\/apids\/.+/, :status => ["200", "OK"], :body => "{\"active\":true,\"alias\":null}")
    FakeWeb.register_uri(:get, /my_app_key\:my_app_secret\@go\.urbanairship.com\/api\/device_tokens\/.+/, :status => ["200", "OK"], :body => "{\"active\":true,\"alias\":null}")
    FakeWeb.register_uri(:get, /bad_key\:my_app_secret\@go\.urbanairship.com\/api\/device_tokens\/.+/, :status => ["401", "Unauthorized"])

    # device_tokens
    FakeWeb.register_uri(:get, "https://my_app_key:my_master_secret@go.urbanairship.com/api/device_tokens/", :status => ["200", "OK"], :body => '{"device_tokens":[{"device_token": "0101F9929660BAD9FFF31A0B5FA32620FA988507DFFA52BD6C1C1F4783EDA2DB","active": false,"alias": null, "tags": []}], "device_tokens_count":50, "active_device_tokens_count":55}')
    FakeWeb.register_uri(:get, "https://my_app_key2:my_master_secret2@go.urbanairship.com/api/device_tokens/", :status => ["401", "OK"])

    # push
    FakeWeb.register_uri(:post, "https://my_app_key:my_master_secret@go.urbanairship.com/api/push/", :status => ["200", "OK"])
    FakeWeb.register_uri(:post, "https://my_app_key2:my_master_secret2@go.urbanairship.com/api/push/", :status => ["400", "Bad Request"])
    FakeWeb.register_uri(:post, /bad_key\:my_master_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])

    # batch_push
    FakeWeb.register_uri(:post, "https://my_app_key:my_master_secret@go.urbanairship.com/api/push/batch/", :status => ["200", "OK"])
    FakeWeb.register_uri(:post, "https://my_app_key2:my_master_secret2@go.urbanairship.com/api/push/batch/", :status => ["400", "Bad Request"])

    # broadcast push
    FakeWeb.register_uri(:post, "https://my_app_key:my_master_secret@go.urbanairship.com/api/push/broadcast/", :status => ["200", "OK"])
    FakeWeb.register_uri(:post, "https://my_app_key2:my_master_secret2@go.urbanairship.com/api/push/broadcast/", :status => ["400", "Bad Request"])

    # delete_scheduled_push
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/push\/scheduled\/[0-9]+/, :status => ["204", "No Content"])
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/push\/scheduled\/alias\/.+/, :status => ["204", "No Content"])
    FakeWeb.register_uri(:delete, /bad_key\:my_master_secret\@go\.urbanairship.com\/api\/push\/scheduled\/[0-9]+/, :status => ["401", "Unauthorized"])

    # feedback
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["200", "OK"], :body => "[{\"device_token\":\"token\",\"marked_inactive_on\":\"2010-10-14T19:15:13Z\",\"alias\":\"my_alias\"}]")
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/device_tokens\/feedback/, :status => ["500", "Internal Server Error"])

    #tags
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags/, :status => ["200", "OK"], :body => "[{\"tags\":[\"tag1\",\"tag2\"]}]")
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/tags/, :status => ["500", "Internal Server Error"])

    #add_tag
    FakeWeb.register_uri(:put, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/new_tag/, :status => ["200", "OK"])
    FakeWeb.register_uri(:put, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/existing_tag/, :status => ["201", "OK"])
    FakeWeb.register_uri(:put, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/tags\/a_tag/, :status => ["500", "Internal Server Error"])

    #remove_tag
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/non_deleted_tag/, :status => ["204", "OK"])
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/deleted_tag/, :status => ["404", "OK"])
    FakeWeb.register_uri(:delete, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/tags\/a_tag/, :status => ["500", "Internal Server Error"])

    #tags_for_device_tokens
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/valid_device_token\/tags/, :status => ["200", "OK"], :body => "[{\"tags\":[\"tag1\",\"tag2\"]}]")
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/invalid_device_token\/tags/, :status => ["404", "OK"])
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/device_tokens\/a_device_token\/tags/, :status => ["500", "Internal Server Error"])

    ##tag_device
    FakeWeb.register_uri(:post, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/new_tag/, :status => ["201", "OK"], :body => '{"device_tokens":{"add":["valid_device_token"]}')
    FakeWeb.register_uri(:post, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/existing_tag/, :status => ["200", "OK"], :body => '{"device_tokens":{"add":["valid_device_token"]}')
    FakeWeb.register_uri(:post, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/tags\/a_tag/, :status => ["500", "Internal Server Error"], :body => '{"device_tokens":{"add":["a_device_token"]}')

    #untag_device
    FakeWeb.register_uri(:post, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/existing_tag/, :status => ["204", "OK"],  :body => '{"device_tokens":{"remove":["valid_device_token"]}')
    FakeWeb.register_uri(:post, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/tags\/non_existant_tag/, :status => ["404", "OK"], :body => '{"device_tokens":{"remove":["valid_device_token"]}')
    FakeWeb.register_uri(:post, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/tags\/a_tag/, :status => ["500", "Internal Server Error"], :body => '{"device_tokens":{"remove":["a_device_token"]}')

    #Get Segment
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/valid_id/, :status => ["200", "OK"], :body => '{"display_name":"Male in NY", "criteria":{"and":[{"tag":"male"}, {"tag":"in NY"}]}}')
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/not_found/, :status => ["404", "OK"])
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/segments\/invalid_segment/, :status => ["500", "Internal Server Error"])

    #Get List of Segments
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments$/, :status => ["200", "OK"], :body => '{"segments":[{"id":"abcd-efgh-ijkl", "display_name":"test1", "creation_date":1360950614201, "modification_date":1360950614201}, {"id": "mnop-qrst-uvwx", "display_name": "test2", "creation_date":1360950614202, "modification_date":1360950614202}]}')
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/segments$/, :status => ["500", "Internal Server Error"])

    #Create Segment
    FakeWeb.register_uri(:post, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments/, :status => ["201", "OK"])
    FakeWeb.register_uri(:post, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/segments/, :status => ["500", "Internal Server Error"])

    #Update Segment
    FakeWeb.register_uri(:put, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/valid_segment/, :status => ["200", "OK"])
    FakeWeb.register_uri(:put, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/invalid_segment/, :status => ["404", "OK"])
    FakeWeb.register_uri(:put, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/segments\/a_segment/, :status => ["500", "Internal Server Error"])

    #Delete Segment
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/valid_segment/, :status => ["204", "OK"])
    FakeWeb.register_uri(:delete, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/segments\/invalid_segment/, :status => ["404", "OK"])
    FakeWeb.register_uri(:delete, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/segments\/a_segment/, :status => ["500", "Internal Server Error"])

    # push to segment
    FakeWeb.register_uri(:post, "https://my_app_key:my_master_secret@go.urbanairship.com/api/push/segments", :status => ["200", "OK"])
    FakeWeb.register_uri(:post, "https://my_app_key2:my_master_secret2@go.urbanairship.com/api/push/segments", :status => ["400", "Bad Request"])
    FakeWeb.register_uri(:post, /bad_key\:my_master_secret\@go\.urbanairship\.com/, :status => ["401", "Unauthorized"])

    #device_tokens_count
    FakeWeb.register_uri(:get, /my_app_key\:my_master_secret\@go\.urbanairship.com\/api\/device_tokens\/count/, :status => ["200", "OK"], :body => "{\"device_tokens_count\":50, \"active_device_tokens_count\":55}")
    FakeWeb.register_uri(:get, /my_app_key2\:my_master_secret2\@go\.urbanairship.com\/api\/device_tokens\/count/, :status => ["500", "Internal Server Error"])
  end

  describe "configuration" do
    it "enables you to configure the application key" do
      subject.application_key.should be_nil
      subject.application_key = "asdf1234"
      subject.application_key.should == "asdf1234"
    end

    it "enables you to configure the application secret" do
      subject.application_secret.should be_nil
      subject.application_secret = "asdf1234"
      subject.application_secret.should == "asdf1234"
    end

    it "enables you to configure the master secret" do
      subject.master_secret.should be_nil
      subject.master_secret = "asdf1234"
      subject.master_secret.should == "asdf1234"
    end
  end

  describe "::tags" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.tags
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.tags
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns valid tags" do
      response = subject.tags
      response.first.should include("tags")
      response.first["tags"].should include("tag1")
      response.first["tags"].should include("tag2")
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.tags.success?.should == false
    end

  end

  describe "::add_tag" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.add_tag('a_tag')
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.add_tag('new_tag')
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "adds a new tag" do
      subject.add_tag('new_tag').success?.should == true
      subject.add_tag('new_tag').code.should == "200"
    end

    it "adds an exisiting tag" do
      subject.add_tag('existing_tag').success?.should == true
      subject.add_tag('existing_tag').code.should == "201"
    end

    it "success? is false when the call doesn't return 200 or 201" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.add_tag('a_tag').success?.should == false
    end

    it "sets the content-type to text/plain" do
      subject.add_tag('new_tag')
      FakeWeb.last_request['content-type'].should == "text/plain"
    end
  end

  describe "::remove_tag" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

   it "raises an error if call is made without an app key and master secret configured" do
     subject.application_key = nil
     subject.master_secret = nil

     lambda {
       subject.remove_tag('a_tag')
     }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
   end

   it "uses app key and secret to sign the request" do
     subject.remove_tag('non_deleted_tag')
     FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
   end

   it "removes a tag that has not been removed yet" do
     subject.remove_tag('non_deleted_tag').success?.should == true
     subject.remove_tag('non_deleted_tag').code.should == "204"
   end

   it "attempts to remove an already deleted tag" do
     subject.remove_tag('deleted_tag').success?.should == false
     subject.remove_tag('deleted_tag').code.should == "404"
   end

   it "success? is false when the call doesn't return 204" do
     subject.application_key = "my_app_key2"
     subject.master_secret = "my_master_secret2"
     subject.add_tag('a_tag').success?.should == false
   end
  end

  describe "::tags_for_device" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
       subject.application_key = nil
       subject.master_secret = nil

       lambda {
         subject.tags_for_device('a_device_token')
       }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.tags_for_device('valid_device_token')
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns valid tags for a device" do
      response = subject.tags_for_device('valid_device_token')
      response.first.should include("tags")
      response.first["tags"].should include("tag1")
      response.first["tags"].should include("tag2")
      response.code.should == "200"
    end

    it "returns invalid response for device token that is not found or registered" do
      response = subject.tags_for_device('invalid_device_token')
      response.code.should == "404"
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.tags_for_device('a_device_token').success?.should == false
    end
  end

  describe "::tag_device" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
       subject.application_key = nil
       subject.master_secret = nil

       lambda {
         subject.tag_device({:device_token => 'a_device_token', :tag => 'a_tag'})
       }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.tag_device({:device_token => 'valid_device_token', :tag => 'new_tag'})
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "adds a valid device token to tag" do
      response = subject.tag_device({:device_token => 'valid_device_token', :tag => 'new_tag'})
      response.code.should == "201"
      response.success?.should == true
    end

    it "adds a valid device token to an existing tag" do
      response = subject.tag_device({:device_token => 'valid_device_token', :tag => 'existing_tag'})
      response.code.should == "204"
      response.success?.should == true
    end
  end

    describe "::untag_device" do
      before(:each) do
        subject.application_key = "my_app_key"
        subject.master_secret = "my_master_secret"
      end

      it "raises an error if call is made without an app key and master secret configured" do
         subject.application_key = nil
         subject.master_secret = nil

         lambda {
           subject.untag_device({:device_token => 'a_device_token', :tag => 'a_tag'})
         }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
      end

      it "uses app key and secret to sign the request" do
        subject.untag_device({:device_token => 'valid_device_token', :tag => 'existing_tag'})
        FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
      end

      it "removes a valid device token from a tag" do
        response = subject.untag_device({:device_token => 'valid_device_token', :tag => 'existing_tag'})
        response.code.should == "204"
        response.success?.should == true
      end

      it "removes a device token from a tag that it is not associated with" do
        response = subject.untag_device({:device_token => 'valid_device_token', :tag => 'non_existant_tag'})
        response.code.should == "404"
        response.success?.should == false
      end
  end

  describe "::register_device" do
    before(:each) do
      @valid_params = {:alias => 'one'}
      subject.application_key = "my_app_key"
      subject.application_secret = "my_app_secret"
    end

    it "raises an error if call is made without an app key and secret configured" do
      subject.application_key = nil
      subject.application_secret = nil

      lambda {
        subject.register_device("asdf1234")
      }.should raise_error(RuntimeError, "Must configure application_key, application_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.register_device("new_device_token")
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_app_secret').chomp}"
    end

    it "takes and sends a device token" do
      subject.register_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/device_tokens/new_device_token"
    end

    it "returns true when the device is registered for the first time" do
      subject.register_device("new_device_token").success?.should == true
    end

    it "returns true when the device is registered again" do
      subject.register_device("existing_device_token").success?.should == true
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.register_device("new_device_token").success?.should == false
    end

    it "accepts an alias" do
      subject.register_device("device_token_one", @valid_params).success?.should == true
    end

    it "adds alias to the JSON payload" do
      subject.register_device("device_token_one", @valid_params)
      request_json['alias'].should == "one"
    end

    it "converts alias param to string" do
      subject.register_device("device_token_one", :alias => 11)
      request_json['alias'].should be_a_kind_of String
    end

    it "uses the iOS interface by default" do
      subject.register_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/device_tokens/new_device_token"
    end

    it "uses the android interface if 'provider' configuration option is set to :android Symbol" do
      subject.provider = :android
      subject.register_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
      subject.provider = nil
    end

    it "uses the android interface if 'provider' configuration option is set to 'android' String" do
      subject.provider = 'android'
      subject.register_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
      subject.provider = nil
    end

    it "uses the android interface if :provider Symbol key is passed an :android Symbol value" do
      subject.register_device("new_device_token", :provider => :android)
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
    end

    it "uses the android interface if 'provider' Symbol key is passed an 'android' String value" do
      subject.register_device("new_device_token", :provider => "android")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
    end

  end

  describe "::unregister_device" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.application_secret = "my_app_secret"
    end

    it "raises an error if call is made without an app key and secret configured" do
      subject.application_key = nil
      subject.application_secret = nil

      lambda {
        subject.unregister_device("asdf1234")
      }.should raise_error(RuntimeError, "Must configure application_key, application_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.unregister_device("key_to_delete")
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_app_secret').chomp}"
    end

    it "sends the key that needs to be deleted" do
      subject.unregister_device("key_to_delete")
      FakeWeb.last_request.path.should == "/api/device_tokens/key_to_delete"
    end

    it "returns true when the device is successfully unregistered" do
      subject.unregister_device("key_to_delete").success?.should == true
      FakeWeb.last_request.body.should be_nil
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.unregister_device("key_to_delete").success?.should == false
    end

    it "uses the android interface if 'provider' configuration option is set to :android Symbol" do
      subject.provider = :android
      subject.unregister_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
      subject.provider = nil
    end

    it "uses the android interface if 'provider' configuration option is set to 'android' String" do
      subject.provider = 'android'
      subject.unregister_device("new_device_token")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
      subject.provider = nil
    end

    it "uses the android interface if :provider Symbol key is passed with an :android Symbol value" do
      subject.unregister_device("new_device_token", :provider => :android)
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
    end

    it "uses the android interface if :provider Symbol key is passed with an 'android' String value" do
      subject.unregister_device("new_device_token", :provider => "android")
      FakeWeb.last_request.path.should == "/api/apids/new_device_token"
    end

  end

  describe "::device_info" do
    before(:each) do
      @valid_params = {:alias => 'one'}
      subject.application_key = "my_app_key"
      subject.application_secret = "my_app_secret"
    end

    it "raises an error if call is made without an app key and secret configured" do
      subject.application_key = nil
      subject.application_secret = nil

      lambda {
        subject.device_info("asdf1234")
      }.should raise_error(RuntimeError, "Must configure application_key, application_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.device_info("device_token")
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_app_secret').chomp}"
    end

    it "takes and sends a device token" do
      subject.device_info("device_token")
      FakeWeb.last_request.path.should == "/api/device_tokens/device_token"
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.device_info("device_token").success?.should == false
    end

    it "uses the iOS interface by default" do
      subject.device_info("device_token")
      FakeWeb.last_request.path.should == "/api/device_tokens/device_token"
    end

    it "uses the android interface if 'provider' configuration option is set to :android Symbol" do
      subject.provider = :android
      subject.device_info("device_token")
      FakeWeb.last_request.path.should == "/api/apids/device_token"
      subject.provider = nil
    end

    it "uses the android interface if 'provider' configuration option is set to 'android' String" do
      subject.provider = 'android'
      subject.device_info("device_token")
      FakeWeb.last_request.path.should == "/api/apids/device_token"
      subject.provider = nil
    end

    it "uses the android interface if :provider Symbol key is passed an :android Symbol value" do
      subject.device_info("device_token", :provider => :android)
      FakeWeb.last_request.path.should == "/api/apids/device_token"
    end

    it "uses the android interface if 'provider' Symbol key is passed an 'android' String value" do
      subject.device_info("device_token", :provider => "android")
      FakeWeb.last_request.path.should == "/api/apids/device_token"
    end

  end

  describe "::delete_scheduled_push" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.delete_scheduled_push("123456789")
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.delete_scheduled_push("123456789")
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "sends the key that needs to be deleted" do
      subject.delete_scheduled_push("123456789")
      FakeWeb.last_request.path.should == "/api/push/scheduled/123456789"
    end

    it "sends the key that needs to be deleted" do
      subject.delete_scheduled_push(123456789)
      FakeWeb.last_request.path.should == "/api/push/scheduled/123456789"
    end

    it "sends the alias that needs to be deleted" do
      subject.delete_scheduled_push(:alias => "alias_to_delete")
      FakeWeb.last_request.path.should == "/api/push/scheduled/alias/alias_to_delete"
    end

    it "returns true when the push notification is successfully deleted" do
      subject.delete_scheduled_push("123456789").success?.should == true
      FakeWeb.last_request.body.should be_nil
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.delete_scheduled_push("123456789").success?.should == false
    end
  end

  describe "::push" do
    before(:each) do
      @valid_params = {:device_tokens => ['device_token_one', 'device_token_two'], :aps => {:alert => 'foo'}}
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.push(@valid_params)
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.push(@valid_params)
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns true when it successfully pushes a notification" do
      subject.push(@valid_params).success?.should == true
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.push(@valid_params).success?.should == false
    end

    it "uses v3 of the API when requested" do
      subject.push(@valid_params.merge(:version => 3)).success?.should == true
      FakeWeb.last_request["Accept"].should == "application/vnd.urbanairship+json; version=3;"
    end

    it "adds schedule_for to the JSON payload" do
      time = Time.parse("Oct 17th, 2010, 8:00 PM UTC")
      subject.push(@valid_params.merge(:schedule_for => [time]))
      request_json['schedule_for'].should == ['2010-10-17T20:00:00Z']
    end

    it "only attempts to format schedule_for if it is a time object" do
      subject.push(@valid_params.merge(:schedule_for => ["2010-10-10 09:09:09 UTC"]))
      request_json['schedule_for'].should == ['2010-10-10T09:09:09Z']
    end

    it "returns false if urbanairship responds with a non-200 response" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.push.success?.should == false
    end

    it "converts aliases to strings" do
      subject.push(@valid_params.merge(:aliases => [:one, 2]))
      request_json['aliases'].should == ['one', '2']
    end

    it "automatically truncates aps payloads to max aps bytes when configured" do
      subject.truncate_aps = true
      large_params = @valid_params
      large_params[:aps][:alert] = "this will be a long alert" * 500
      subject.push(large_params).success?.should == true
      request_json.to_json.bytesize.should == Urbanairship::Client::MAX_APS_BYTES
      subject.truncate_aps = false
    end

    it "does not automatically truncate aps payloads to max aps bytes when not configured" do
      large_params = @valid_params
      large_params[:aps][:alert] = "this will be a long alert" * 500
      subject.push(large_params).success?.should == true
      request_json.to_json.bytesize.should_not == Urbanairship::Client::MAX_APS_BYTES
    end
  end

  describe "::push_to_segment" do
    before(:each) do
      @valid_params = {:segments => ['segment-id'], :aps => {:alert => 'foo'}}
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.push(@valid_params)
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.push_to_segment(@valid_params)
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns true when it successfully pushes a notification" do
      subject.push_to_segment(@valid_params).success?.should == true
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.push_to_segment(@valid_params).success?.should == false
    end

    it "adds schedule_for to the JSON payload" do
      time = Time.parse("Oct 17th, 2010, 8:00 PM UTC")
      subject.push_to_segment(@valid_params.merge(:schedule_for => [time]))
      request_json['schedule_for'].should == ['2010-10-17T20:00:00Z']
    end

    it "only attempts to format schedule_for if it is a time object" do
      subject.push_to_segment(@valid_params.merge(:schedule_for => ["2010-10-10 09:09:09 UTC"]))
      request_json['schedule_for'].should == ['2010-10-10T09:09:09Z']
    end

    it "returns false if urbanairship responds with a non-200 response" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.push_to_segment.success?.should == false
    end
  end

  describe "::batch_push" do
    before(:each) do
      @valid_params = [
        {:device_tokens => ['device_token_one', 'device_token_two'], :aps => {:alert => 'foo'}},
        {:device_tokens => ['device_token_three', 'device_token_four'], :aps => {:alert => 'bar'}}
      ]
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.batch_push(@valid_params)
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.batch_push(@valid_params)
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns true when it successfully pushes a notification" do
      subject.batch_push(@valid_params).success?.should == true
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.batch_push(@valid_params).success?.should == false
    end

    it "adds schedule_for to the JSON payload" do
      time = Time.parse("Oct 17th, 2010, 8:00 PM UTC")
      @valid_params[0].merge!(:schedule_for => [time])
      subject.batch_push(@valid_params)
      request_json[0]['schedule_for'].should == ['2010-10-17T20:00:00Z']
    end

    it "accepts strings as schedule_for values" do
      @valid_params[0].merge!(:schedule_for => ["2010-10-10 09:09:09 UTC"])
      subject.batch_push(@valid_params)
      request_json[0]['schedule_for'].should == ['2010-10-10T09:09:09Z']
    end

    it "returns false if urbanairship responds with a non-200 response" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.batch_push.success?.should == false
    end
  end

  describe "::broadcast_push" do
    before(:each) do
      @valid_params = {:aps => {:alert => 'foo'}}
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.broadcast_push(@valid_params)
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.broadcast_push(@valid_params)
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns true when it successfully pushes a notification" do
      subject.broadcast_push(@valid_params).success?.should == true
    end

    it "returns false when the authorization is invalid" do
      subject.application_key = "bad_key"
      subject.broadcast_push(@valid_params).success?.should == false
    end

    it "adds schedule_for to the JSON payload" do
      time = Time.parse("Oct 17th, 2010, 8:00 PM UTC")
      @valid_params[:schedule_for] = [time]
      subject.broadcast_push(@valid_params)
      request_json['schedule_for'].should == ['2010-10-17T20:00:00Z']
    end

    it "accepts strings as schedule_for values" do
      @valid_params[:schedule_for] = ["2010-10-10 09:09:09 UTC"]
      subject.broadcast_push(@valid_params)
      request_json['schedule_for'].should == ['2010-10-10T09:09:09Z']
    end

    it "returns false if urbanairship responds with a non-200 response" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.broadcast_push.success?.should == false
    end
  end

  describe "::feedback" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.feedback(Time.now)
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.feedback(Time.now)
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "encodes the time argument in UTC, ISO 8601 format" do
      time = Time.parse("October 10, 2010, 8:00pm")
      formatted_time = time.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
      subject.feedback(time)
      FakeWeb.last_request.path.should include(formatted_time)
    end

    it "accepts a string as the time argument" do
      subject.feedback("Oct 07, 2010 8:00AM UTC")
      FakeWeb.last_request.path.should include("2010-10-07T08:00:00Z")
    end

    it "returns an array of responses from the feedback API" do
      response = subject.feedback(Time.now)
      response[0].should include("device_token")
      response[0].should include("marked_inactive_on")
      response[0].should include("alias")
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.feedback(Time.now).success?.should == false
    end
  end

  describe "::device_tokens" do

    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.device_tokens_count
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.device_tokens_count
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns a hash as response from the Device Token List API with an array of device tokens" do
      response = subject.device_tokens
      response["device_tokens"].class.should == Array
      response["device_tokens_count"].should == 50
      response["active_device_tokens_count"].should == 55
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.device_tokens.success?.should == false
    end

  end

  describe "::device_tokens_count" do

    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.device_tokens_count
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.device_tokens_count
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns a hash as response from the Device Token List API" do
      response = subject.device_tokens_count
      response["device_tokens_count"].should == 50
      response["active_device_tokens_count"].should == 55
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.device_tokens_count.success?.should == false
    end

  end

  describe "::segments" do
    before(:each) do
      subject.application_key = "my_app_key"
      subject.master_secret = "my_master_secret"
      @valid_segment = {:display_name => "Test Male NY", :criteria => {:and => [ {:tag => "male"}, {:tag => "NY"}]} }
    end

    it "raises an error if call is made without an app key and master secret configured" do
      subject.application_key = nil
      subject.master_secret = nil

      lambda {
        subject.segments
      }.should raise_error(RuntimeError, "Must configure application_key, master_secret before making this request.")
    end

    it "uses app key and secret to sign the request" do
      subject.segments
      FakeWeb.last_request['authorization'].should == "Basic #{Base64::encode64('my_app_key:my_master_secret').chomp}"
    end

    it "returns valid segments" do
      response = subject.segments
      response.first.should include("segments")
      response["segments"].each do |s|
        ["id", "display_name", "creation_date", "modification_date"].each do |k|
          s.should include(k)
        end
      end
    end

    it "can create a valid segment" do
      response = subject.create_segment(@valid_segment)
      response.code.should == "201"
    end

    it "can get a segment given its id" do
      response = subject.segment("valid_id")
      response.code.should == "200"
      response.should include("display_name")
      response.should include("criteria")
    end

    it "returns not found if invalid segment id is given" do
      response = subject.segment("not_found")
      response.code.should == "404"
    end

    it "can update a segment given a valid id" do
      response = subject.update_segment("valid_segment", @valid_segment)
      response.code.should == "200"
    end

    it "cant update a segment when given an invalid id" do
      response = subject.update_segment("invalid_segment", @valid_segment)
      response.code.should == "404"
    end

    it "can delete a segment given a valid id" do
      response = subject.delete_segment("valid_segment")
      response.code.should == "204"
    end

    it "cant delete a segment given an invalid id" do
      response = subject.delete_segment("invalid_segment")
      response.code.should == "404"
    end

    it "success? is false when the call doesn't return 200" do
      subject.application_key = "my_app_key2"
      subject.master_secret = "my_master_secret2"
      subject.segments.success?.should == false
    end

  end


  describe "logging" do

    before(:each) do
      @logger = mock("logger", :info => true)
      subject.application_key = "my_app_key"
      subject.application_secret = "my_app_secret"
      subject.master_secret = "my_master_secret"
      subject.logger = @logger
    end

    it "logs request and response information when registering a device" do
      @logger.should_receive(:info).with(/\/api\/device_tokens\/new_device_token/)
      subject.register_device('new_device_token')
    end

    it "logs request and response information when sending push notifications" do
      @logger.should_receive(:info).with(/\/api\/push/)
      subject.push(:device_tokens => ["device_token"], :aps => {:alert => "foo"})
    end

    it "logs request and response information when sending batch push notifications" do
      @logger.should_receive(:info).with(/\/api\/push\/batch/)
      subject.batch_push([:device_tokens => ["device_token"], :aps => {:alert => "foo"}])
    end

    it "logs request and response information when sending feedback requests" do
      @logger.should_receive(:info).with(/\/api\/device_tokens\/feedback/)
      subject.feedback(Time.now)
    end

    it "flushes the logger buffer if it's an ActiveSupport::BufferedLogger (Default Rails logger)" do
      @logger.stub(:flush).and_return("message in the buffer\n")
      @logger.should_receive(:flush)
      subject.feedback(Time.now)
    end
  end

  describe "request timeout" do
    before(:each) do
      @logger = mock("logger", :info => true)
      subject.application_key = "my_app_key"
      subject.application_secret = "my_app_secret"
      subject.master_secret = "my_master_secret"
      subject.logger = @logger
    end

    it "does not attempt to log if logger is not set" do
      Urbanairship::Timer.should_receive(:timeout).with(5.0).and_raise(Timeout::Error)
      subject.logger = nil

      lambda {
        subject.register_device('new_device_token')
      }.should_not raise_exception(NoMethodError)
    end

    it "uses a default request_timeout value of five seconds" do
      Urbanairship::Timer.should_receive(:timeout).with(5.0).and_raise(Timeout::Error)
      @logger.should_receive(:error).with(/Urbanairship request timed out/)

      subject.register_device('new_device_token')
    end

    it "accepts a configured request_timeout value" do
      Urbanairship::Timer.should_receive(:timeout).with(1.23).and_raise(Timeout::Error)
      @logger.should_receive(:error).with(/Urbanairship request timed out/)

      subject.request_timeout = 1.23
      subject.register_device('new_device_token')
    end
  end
end

describe Urbanairship do
  it_should_behave_like "an Urbanairship client"
end

describe Urbanairship::Client do
  it_should_behave_like "an Urbanairship client"
end

def request_json
  JSON.parse FakeWeb.last_request.body
end
