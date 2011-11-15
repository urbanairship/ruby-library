Urbanairship is a Ruby library for interacting with the [Urbanairship API](http://urbanairship.com).

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
Urbanairship.register_device 'DEVICE-TOKEN' # => true
```

Unregistering a device token
----------------------------
```ruby
Urbanairship.unregister_device 'DEVICE-TOKEN' # => true
```

Sending a push notification
---------------------------
```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :device_tokens => ['DEVICE-TOKEN-ONE', 'DEVICE-TOKEN-TWO'],
  :aps => {:alert => 'You have a new message!', :badge => 1}
}

Urbanairship.push notification # => true
```

Batching push notification sends
--------------------------------
```ruby
notifications = [
  {
    :schedule_for => [{ :alias => 'deadbeef', :scheduled_time => 1.hour.from_now }],   # assigning an alias to a scheduled push
    :device_tokens => ['DEVICE-TOKEN-ONE', 'DEVICE-TOKEN-TWO'],
    :aps => {:alert => 'You have a new message!', :badge => 1}
  },
  {
    :schedule_for => [3.hours.from_now],
    :device_tokens => ['DEVICE-TOKEN-THREE'],
    :aps => {:alert => 'You have a new message!', :badge => 1}
  }
]

Urbanairship.batch_push notifications # => true
```


Sending broadcast notifications
-------------------------------
Urbanairship allows you to send a broadcast notification to all active registered device tokens for your app.

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :aps => {:alert => 'Important announcement!', :badge => 1}
}

Urbanairship.broadcast_push notification # => true
```

Polling the feedback API
------------------------
The first time you attempt to send a push notification to a device that has uninstalled your app (or has opted-out of notifications), both Apple and Urbanairship will register that token in their feedback API. Urbanairship will prevent further attempted notification sends to that device, but it's a good practice to periodically poll Urbanairship's feedback API and mark those tokens as inactive in your own system as well.

```ruby
# find all device tokens deactivated in the past 24 hours
Urbanairship.feedback 24.hours.ago # =>
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

If you know the alias or id of a scheduled push notification then you can delete it from Urbanairship's queue and it will not be delivered.

```ruby
Urbanairship.delete_scheduled_push("123456789") # => true
Urbanairship.delete_scheduled_push(123456789) # => true
Urbanairship.delete_scheduled_push(:alias => "deadbeef") # => true
```
