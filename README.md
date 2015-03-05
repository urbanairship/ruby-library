Urbanairship is a Ruby library for interacting with the [Urban Airship API](http://urbanairship.com).

Installation
============
    gem install urbanairship

Note: if you are using Ruby 1.8, you should also install the ```system_timer``` gem for more reliable timeout behaviour. See http://ph7spot.com/musings/system-timer for more information.

Configuration
=============
```ruby
Urbanairship.application_key = 'application-key'
Urbanairship.application_secret = 'application-secret'
Urbanairship.master_secret = 'master-secret'
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5 # default
```

Usage
=====

Registering a device token
--------------------------
```ruby
Urbanairship.register_device('DEVICE-TOKEN')
```
You can also pass an alias, and a set of tags to device registration.
```ruby
Urbanairship.register_device('DEVICE-TOKEN',
  :alias => 'user-123',
  :tags => ['san-francisco-users']
)
```

Unregistering a device token
----------------------------
```ruby
Urbanairship.unregister_device('DEVICE-TOKEN')
```

Retrieving Device Info
----------------------------
```ruby
Urbanairship.device_info('DEVICE-TOKEN')
```

Sending a push notification
---------------------------
```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :device_tokens => ['DEVICE-TOKEN-ONE', 'DEVICE-TOKEN-TWO'],
  :aps => {:alert => 'You have a new message!', :badge => 1}
}

Urbanairship.push(notification) # =>
# {
#   "scheduled_notifications" => ["https://go.urbanairship.com/api/push/scheduled/123456"]
# }
```

If you wish to use v3 of the Urbanairship API, just add `version: 3` as an option:

```ruby
Urbanairship.push notification.merge(version: 3)
```
### Using aliases instead of device tokens ###

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :aliases => ['ALIAS-ONE', 'ALIAS-TWO'],
  :aps => {:alert => 'You have a new message!', :badge => 1}
}

Urbanairship.push(notification) # =>
# {
#   "scheduled_notifications" => ["https://go.urbanairship.com/api/push/scheduled/123456"]
# }
```

Batching push notification sends
--------------------------------
```ruby
notifications = [
  {
    :schedule_for => [{ :alias => 'deadbeef', :scheduled_time => 1.hour.from_now }],
    :device_tokens => ['DEVICE-TOKEN-ONE', 'DEVICE-TOKEN-TWO'],
    :aps => {:alert => 'You have a new message!', :badge => 1}
  },
  {
    :schedule_for => [3.hours.from_now],
    :device_tokens => ['DEVICE-TOKEN-THREE'],
    :aps => {:alert => 'You have a new message!', :badge => 1}
  }
]

Urbanairship.batch_push(notifications)
```

Sending broadcast notifications
-------------------------------
Urban Airship allows you to send a broadcast notification to all active registered device tokens for your app.

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :aps => {:alert => 'Important announcement!', :badge => 1}
}

Urbanairship.broadcast_pushpnotification())```

Per push infomation
-------------------------------
Urban Airship will return a push_id every time you send a push notification. Using this push_id you can retrieve per push reports.

```ruby
options = {
  :push_id = > '20a91d8a-4124-4e4d-810e-0337ab9ebda9'
}

Urbanairship.push_info options.merge(version: 3) # =>

#{
#"app_key":"vDt0ksKoS7CrKNyg1NpdHQ","push_id":"01a91d8a-4124-4e4d-810e-0337ab9ebda9","created":"2015-03-01 22:35:45","push_body":"eyJhdWRpZW5jZSI6eyJhbmQiOlt7InRhZyI6WyJnYW1lcy1uYmEtcXVhcnRlci0xMCIsImdhbWVzLW5iYS1xdWFydGVyLTUiLCJnYW1lcy1uYmEtcXVhcnRlci0xNDU5OTIwIiwiZ2FtZXMtbmJhLXF1YXJ0ZXIiXX1dfSwiZGV2aWNlX3R5cGVzIjpbImlvcyIsImFuZHJvaWQiXSwibm90aWZpY2F0aW9uIjp7ImFsZXJ0IjoiRW5kIG9mIDNyZDogQ2F2YWxpZXJzIDc0LCBSb2NrZXRzIDgyLiIsImlvcyI6eyJzb3VuZCI6ImRlZmF1bHQiLCJleHRyYSI6eyJvdCI6ZmFsc2UsImhvbWVfc2NvcmUiOjgyLCJjbG9jayI6IjA6MDAiLCJpc19hY3RpdmUiOmZhbHNlLCJsZWFndWUiOiJuYmEiLCJnYW1lX3N0YXR1cyI6IkluLVByb2dyZXNzIiwiaWQiOjE0NTk5MjAsImhvbWVfY2l0eSI6IkhvdXN0b24iLCJob21lX3RlYW1fbmFtZSI6IlJvY2tldHMiLCJ2aXNpdGluZ19jaXR5IjoiQ2xldmVsYW5kIiwidmlzaXRpbmdfc2NvcmUiOjc0LCJzdGFydGVkX2F0IjoxNDI1MjQxODAwLCJob21lX3RlYW1faWQiOjEwLCJ2aXNpdGluZ190ZWFtX2lkIjo1LCJ2aXNpdGluZ190ZWFtX25hbWUiOiJDYXZhbGllcnMiLCJxdWFydGVyIjozfX0sImFuZHJvaWQiOnsiZXh0cmEiOnsiaWQiOiIxNDU5OTIwIiwiZ2FtZV9zdGF0dXMiOiJJbi1Qcm9ncmVzcyIsImlzX2FjdGl2ZSI6ImZhbHNlIiwicXVhcnRlciI6IjMiLCJsZWFndWUiOiJuYmEiLCJjbG9jayI6IjA6MDAiLCJob21lX3Njb3JlIjoiODIiLCJ2aXNpdGluZ19zY29yZSI6Ijc0IiwiaG9tZV9jaXR5IjoiSG91c3RvbiIsInZpc2l0aW5nX2NpdHkiOiJDbGV2ZWxhbmQiLCJob21lX3RlYW1fbmFtZSI6IlJvY2tldHMiLCJ2aXNpdGluZ190ZWFtX25hbWUiOiJDYXZhbGllcnMiLCJob21lX3RlYW1faWQiOiIxMCIsInZpc2l0aW5nX3RlYW1faWQiOiI1Iiwic3RhcnRlZF9hdCI6IjE0MjUyNDE4MDAiLCJvdCI6ImZhbHNlIn19fX0=","sends":0,"direct_responses":0,"influenced_responses":0,"rich_sends":0,"rich_responses":0,"rich_deletions":0,"platforms":{"ios":{"sends":0,"direct_responses":0,"influenced_responses":0},"android":{"sends":0,"direct_responses":0,"influenced_responses":0},"amazon":{"sends":0,"direct_responses":0,"influenced_responses":0}}
#}

```


Polling the feedback API
------------------------
The first time you attempt to send a push notification to a device that has uninstalled your app (or has opted-out of notifications), both Apple and Urban Airship will register that token in their feedback API. Urban Airship will prevent further attempted notification sends to that device, but it's a good practice to periodically poll Urban Airship's feedback API and mark those tokens as inactive in your own system as well.

```ruby
# find all device tokens deactivated in the past 24 hours
Urbanairship.feedback(24.hours.ago) # =>
# [
#   {
#     "marked_inactive_on"=>"2011-06-03 22:53:23",
#     "alias"=>nil,
#     "device_token"=>"DEVICE-TOKEN-ONE"
#   },
#   {
#     "marked_inactive_on"=>"2011-06-03 22:53:23",
#     "alias"=>nil,
#     "device_token"=>"DEVICE-TOKEN-TWO"
#   }
# ]
```

Deleting scheduled notifications
--------------------------------

If you know the alias or id of a scheduled push notification then you can delete it from Urban Airship's queue and it will not be delivered.

```ruby
Urbanairship.delete_scheduled_push("123456789")
Urbanairship.delete_scheduled_push(123456789)
Urbanairship.delete_scheduled_push(:alias => "deadbeef")
```

Segments
---------------------------
Urban Airship segments let you send a push notification to a subset of relevant users based on location, time, preferences, and behavior. You can read more about segments in the [Urban Airship docs](https://docs.urbanairship.com/display/DOCS/Server%3A+Segments+API).

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :segments => ['SEGMENT-ID'],
  :ios => {
    :aps => {
      :alert => 'You have a new message!', :badge => 1
    }
  },
  :android => {
    :alert => 'You have a new message!', :badge => 1
  }
}

Urbanairship.push_to_segment(notification)
```

### Creating a segment ###
``` ruby
Urbanairship.create_segment({
  :display_name => 'segment1',
  :criteria => {:and => [{:tag => 'one'}, {:tag => 'two'}]}
}) # => {}
```

### Listing your segments ###

```ruby
Urbanairship.segments # =>
# {
#   "segments" => [
#     {
#      "id" => "abcd-efgh-ijkl",
#      "display_name" => "segment1",
#      "creation_date" => 1360950614201,
#      "modification_date" => 1360950614201
#     }
#   ]
# }

Urbanairship.segment("abcd-efgh-ijkl") # =>
# {
#  "id" => "abcd-efgh-ijkl",
#  "display_name" => "segment1",
#  "creation_date" => 1360950614201,
#  "modification_date" => 1360950614201
# }
```

### Modifying a segment ###
Note that you must provide both the display name and criteria when updating a segment, even if you are only changing one or the other.
``` ruby
Urbanairship.update_segment('abcd-efgh-ijkl', {
  :display_name => 'segment1',
  :criteria => {:and => [{:tag => 'asdf'}]}
}) # => {}
```

### Deleting a segment ###
```ruby
Urbanairship.delete_segment("abcd-efgh-ijkl") # => {}
```

Getting your device tokens
-------------------------------------
```ruby
Urbanairship.device_tokens # =>
# {
#   "device_tokens" => {"device_token"=>"<token>", "active"=>true, "alias"=>"<alias>", "tags"=>[]},
#   "device_tokens_count" => 3,
#   "active_device_tokens_count" => 1
# }
```

Getting a count of your device tokens
-------------------------------------
```ruby
Urbanairship.device_tokens_count # =>
# {
#   "device_tokens_count" => 3,
#   "active_device_tokens_count" => 1
# }
```

Tags
----

Urban Airship allows you to create tags and associate them with devices. Then you can easily send a notification to every device matching a certain tag with a single call to the push API.

### Creating a tag ###

Tags must be registered before you can use them.

```ruby
Urbanairship.add_tag('TAG')
```

### Listing your tags ###

```ruby
Urbanairship.tags
```

### Removing a tag ##

This will remove a tag from your set of registered tags, as well as removing that tag from any devices that are currently using it.

```ruby
Urbanairship.remove_tag('TAG')
```

### View tags associated with device ###

```ruby
Urbanairship.tags_for_device('DEVICE-TOKEN')
```

### Tag a device ###

```ruby
Urbanairship.tag_device(:device_token => 'DEVICE-TOKEN', :tag => 'TAG')
```

You can also tag a device during device registration.

```ruby
Urbanairship.register_device('DEVICE-TOKEN', :tags => ['san-francisco-users'])
```

### Untag a device ###

```ruby
Urbanairship.untag_device(:device_token => 'DEVICE-TOKEN', :tag => 'TAG')
```

### Sending a notification to all devices with a given tag ###

```ruby
notification = {
  :tags => ['san-francisco-users'],
  :aps => {:alert => 'Good morning San Francisco!', :badge => 1}
}

Urbanairship.push(notification)
```

Using Urbanairship with Android
-------------------------------

The Urban Airship API extends a subset of their push API to Android devices. You can read more about what is currently supported [here](https://docs.urbanairship.com/display/DOCS/Server%3A+Android+Push+API), but as of this writing, only registration, aliases, tags, broadcast, individual push, and batch push are supported.

To use this library with Android devices, you can set the `provider` configuration option to `:android`:

```ruby
Urbanairship.provider = :android
```

Alternatively, you can pass the `:provider => :android` option to device registration calls if your app uses Urbanairship to send notifications to both Android and iOS devices.

```ruby
Urbanairship.register_device("DEVICE-TOKEN", :provider => :android)
```

Note: all other supported actions use the same API endpoints as iOS, so it is not necessary to specify the provider as `:android` when calling them.

When sending notifications to Android devices, the Urban Airship API expects the following basic structure:

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :apids => ['DEVICE-TOKEN-ONE', 'DEVICE-TOKEN-TWO'],
  :android => {:alert => 'You have a new message!', :extra => {:foo => 'bar'}}
}

Urbanairship.push(notification)
```

-----------------------------

Note: all public library methods will return either an array or a hash, depending on the response from the Urban Airship API. In addition, you can inspect these objects to find out if they were successful or not, and what the http response code from Urban Airship was.

```ruby
response = Urbanairship.push(payload)
response.success? # => true
response.code # => '200'
response.inspect # => "{\"scheduled_notifications\"=>[\"https://go.urbanairship.com/api/push/scheduled/123456\"]}"
```

If the call to Urban Airship times out, you'll get a response object with a '503' code.

```ruby
response = Urbanairship.feedback(1.year.ago)
response.success? # => false
response.code # => '503'
response.inspect # => "{\"error\"=>\"Request timeout\"}"
```

Instantiating an Urbanairship::Client
-------------------------------------

Anything you can do directly with the Urbanairship module, you can also do with a Client.

```ruby
client = Urbanairship::Client.new
client.application_key = 'application-key'
client.application_secret = 'application-secret'
client.register_device('DEVICE-TOKEN')
notification = {
  :schedule_for => [1.hour.from_now],
  :device_tokens => ['DEVICE-TOKEN'],
  :aps => {:alert => 'You have a new message!', :badge => 1}
}

client.push(notification) # =>
# {
#   "scheduled_notifications" => ["https://go.urbanairship.com/api/push/scheduled/123456"]
# }
```

This can be used to use clients for different Urbanairship applications in a thread-safe manner.
