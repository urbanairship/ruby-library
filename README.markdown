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
Urban Airship allows you to send a broadcast notification to all active registered device tokens for your app.

```ruby
notification = {
  :schedule_for => [1.hour.from_now],
  :aps => {:alert => 'Important announcement!', :badge => 1}
}

Urbanairship.broadcast_push notification # => true
```

Polling the feedback API
------------------------
The first time you attempt to send a push notification to a device that has uninstalled your app (or has opted-out of notifications), both Apple and Urban Airship will register that token in their feedback API. Urban Airship will prevent further attempted notification sends to that device, but it's a good practice to periodically poll Urban Airship's feedback API and mark those tokens as inactive in your own system as well.

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

If you know the alias or id of a scheduled push notification then you can delete it from Urban Airship's queue and it will not be delivered.

```ruby
Urbanairship.delete_scheduled_push("123456789") # => true
Urbanairship.delete_scheduled_push(123456789) # => true
Urbanairship.delete_scheduled_push(:alias => "deadbeef") # => true
```

Error checking with responses
-----------------------------

Each public method in Urbanairship returns an object with a base class of ```Urbanairship::Response```. This base class contains debugging information
about the previous operation that was performed.

To find out if an operation was successful use the ```success?``` method. 

```ruby
response = Urbanairship.push(payload)
if response.success?
  # yay done!
else
  # give up
end
```

To find the exact code of your last request use ```code```

```ruby
response = Urbanairship.push(payload)
response.code # "200"
```

Expecting a JSON body back? We have you covered. It just so happens that ```Urbanairship::Response``` inherits ```Hash``` and binds the JSON body to its self.
So if your working with the feedback you can iterate over each item returned.

```ruby
response = Urbanairship.feedback(Time.now)

response.each do |device_token|
  # do stuff
end
```
