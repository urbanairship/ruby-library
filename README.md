[![Build Status](https://travis-ci.org/urbanairship/ruby-library.svg?branch=api-v3)](https://travis-ci.org/urbanairship/ruby-library)

# Urbanairship

`urbanairship` is a Ruby library for using the [Urban Airship](www.urbanairship.com) web service API for push notifications and rich app pages.

## Requirements
As of Version 3.0, a Ruby version >= 2.0 must be used.

## Functionality

Version 3.0 is a major upgrade and backwards incompatible with earlier versions. This release focuses on support for the new version 3 push API. There is also a major reorganization of the codebase.

To encourage the use of our SDK, which takes care of proper channel registration, support for device token registration has been removed. Support for v1 endpoints has also been removed and support for:

* blackberry pin lookup,
* lookup and listing for device tokens, and
* sending to device tokens

has been moved from v1 to v3.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'urbanairship'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install urbanairship

## Usage

Once the gem has been installed you can start sending pushes!

###Broadcast to All Devices
```ruby
require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'application_key', secret:'master_secret')
p = UA::Push::Push::PlainPush.new(airship)
p.audience = UA.all_
p.notification = UA.notification(alert: 'Hello')  
p.device_types = UA.all_
p.send_push
```

###Simple Tag Push
```ruby
require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'application_key', secret:'master_secret')
p = UA::Push::Push::PlainPush.new(airship)
p.audience = UA.tag('some_tag')
p.notification = UA.notification(alert: 'Hello')  
p.device_types = UA.all_
p.send_push
```

## Questions
The best place to ask questions is our support site: http://support.urbanairship.com/

## Contributing

1. Fork it ( https://github.com/urbanairship/ruby-library )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Sign Urban Airship's [contribution agreement](http://urbanairship.com/legal/contribution-agreement) 
Note: Changes will not be approved and merged without a signed contribution agreement

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
