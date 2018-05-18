.. image:: https://travis-ci.org/urbanairship/ruby-library.svg?branch=master
    :target: https://travis-ci.org/urbanairship/ruby-library

About
=====

``urbanairship`` is a Ruby library for using the `Urban Airship
<http://urbanairship.com/>`_ web service API for push notifications
and rich app pages.


Requirements
============

We officially support the following Ruby versions::

   2.2.5
   2.3.1

Newer versions should work as well.


Functionality
=============

Version 4.0 is a major upgrade, as some features have been removed that were present in earlier versions. A more detailed list of changes can be found in the CHANGELOG.


Installation
============

If you have the ``bundler`` gem (if not you can get it with
``$ gem install bundler``) add this line to your application's
Gemfile::

    >>> gem 'urbanairship'

And then execute::

    >>> $ bundle

OR install it yourself as::

    >>> gem install urbanairship


Configuration
=============

In your app initialization, you can do something like the following:

    >>> require 'urbanairship'
    >>> Urbanairship.configure do |config|
    >>>   config.log_path = '/path/to/your/logfile'
    >>>   config.log_level = Logger::WARN
    >>>   config.timeout = 60
    >>> end


Available Configurations
------------------------

- **log_path**: Allows to define the folder where the log file will be created (the default is nil).
- **log_level**: Allows to define the log level and only messages at that level or higher will be printed (the default is INFO).
- **timeout**: Allows to define the request timeout in seconds (the default is 5).


Usage
=====

Once the gem has been installed you can start sending pushes!
See the `full documentation
<http://docs.urbanairship.com/reference/libraries/ruby>`_,
`api examples
<http://docs.urbanairship.com/topic-guides/api-examples.html>`_, as well as the
`Urban Airship API Documentation
<http://docs.urbanairship.com/api/>`_ for more
information.


Broadcast to All Devices
------------------------

    >>> require 'urbanairship'
    >>> UA = Urbanairship
    >>> airship = UA::Client.new(key:'application_key', secret:'master_secret')
    >>> p = airship.create_push
    >>> p.audience = UA.all
    >>> p.notification = UA.notification(alert: 'Hello')
    >>> p.device_types = UA.all
    >>> p.send_push


Simple Tag Push
---------------

    >>> require 'urbanairship'
    >>> UA = Urbanairship
    >>> airship = UA::Client.new(key:'application_key', secret:'master_secret')
    >>> p = airship.create_push
    >>> p.audience = UA.tag('some_tag')
    >>> p.notification = UA.notification(alert: 'Hello')
    >>> p.device_types = UA.all
    >>> p.send_push


Questions
=========

The best place to ask questions is our support site:
http://support.urbanairship.com/


Contributing
============

1. Fork it ( https://github.com/urbanairship/ruby-library )
2. Create your feature branch: ``git checkout -b my-new-feature``
3. Commit your changes ``git commit -am 'Add some feature'``
4. Push to the branch ``git push origin my-new-feature``
5. Create a new Pull Request
6. Sign Urban Airship's `contribution agreement
   <http://docs.urbanairship.com/contribution-agreement.html>`_.

**Note**: Changes will not be approved and merged without a signed
contribution agreement.


Development
===========

After checking out the repo, ensure you have ``bundler`` installed
(``$ gem install bundler``) run::

    >>> $ bin/setup

to install dependencies. Then, run::

    >>> $ bin/console

for an interactive prompt that will allow you to experiment.

OR you can build a local gem to play with::

    >>> $ gem build urbanairship.gemspec
    >>> $ gem install ./urbanairship-<VERSION>.gem

Having a local build will give you better logging if you are running
into issues, but be careful to make sure to use our released public
gem in Production.
