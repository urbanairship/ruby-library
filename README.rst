.. image:: https://github.com/urbanairship/ruby-library/actions/workflows/ci.yaml/badge.svg
    :target: https://github.com/urbanairship/ruby-library/
About
=====

``urbanairship`` is a Ruby library for using the `Airship
<http://airship.com/>`_ REST API for push notifications, message
center messages, email, and SMS.


Requirements
============

We officially support the following Ruby versions::

   2.6.7
   2.7.2

Newer 2.x versions should work as well.


Functionality
=============

Version 8.0 is a major upgrade, as we have changed the tested/supported versions of Ruby. A more detailed list of changes can be found in the CHANGELOG.


Questions
=========

The best place to ask questions or report a problem is our support site:
http://support.airship.com/


Installation
============

If you have the ``bundler`` gem (if not you can get it with
``$ gem install bundler``) add this line to your application's
Gemfile:

.. code-block::

   >>> $ gem 'urbanairship'

And then execute:

.. code-block::

   >>> $ bundle

OR install it yourself as:

.. code-block::

   >>> $ gem install urbanairship


Configuration
=============

In your app initialization, you can do something like the following:

.. code-block:: ruby

   require 'urbanairship'

   Urbanairship.configure do |config|
     config.server = 'go.airship.eu'
     config.log_path = '/path/to/your/logfile'
     config.log_level = Logger::WARN
     config.timeout = 60
   end


If you want to use a custom logger (e.g Rails.logger), you can do:

.. code-block:: ruby

   require 'urbanairship'

   Urbanairship.configure do |config|
     config.custom_logger = Rails.logger
     config.log_level = Logger::WARN
   end

Available Configurations
------------------------

- **log_path**: Allows to define the folder where the log file will be created (the default is nil).
- **log_level**: Allows to define the log level and only messages at that level or higher will be printed (the default is INFO).
- **server**: Allow to define the Airship server you want to use ("go.airship.eu" or "go.urbanairship.com")
- **timeout**: Allows to define the request timeout in seconds (the default is 5).


Usage
=====

Once the gem has been installed you can start sending pushes!
See the `full documentation
<http://docs.airship.com/reference/libraries/ruby>`_,
`api examples
<http://docs.airship.com/topic-guides/api-examples.html>`_, as well as the
`Airship API Documentation
<http://docs.airship.com/api/>`_ for more
information.


Broadcast to All Devices
------------------------

.. code-block:: ruby

   require 'urbanairship'

   UA = Urbanairship

   airship = UA::Client.new(key:'application_key', secret:'master_secret')
   p = airship.create_push
   p.audience = UA.all
   p.notification = UA.notification(alert: 'Hello')
   p.device_types = UA.device_types(['ios','android'])
   p.send_push

Simple Tag Push
---------------

.. code-block:: ruby

   require 'urbanairship'

   UA = Urbanairship

   airship = UA::Client.new(key:'application_key', secret:'master_secret')
   p = airship.create_push
   p.audience = UA.tag('some_tag')
   p.notification = UA.notification(alert: 'Hello')
   p.device_types = UA.device_types(['ios','android'])
   p.send_push

Specify the Airship server used to make your requests
-----------------------------------------------------
By default, the request will be sent to the 'go.urbanairship.com' server:

.. code-block:: ruby

   require 'urbanairship'

   Urbanairship::Client.new(key:'application_key', secret:'master_secret')

You can change the server globally in the Urbanairship configuration:

.. code-block:: ruby

   require 'urbanairship'

   Urbanairship.configure do |config|
     config.server = 'go.airship.eu'
   end

   Urbanairship::Client.new(key:'application_key', secret:'master_secret')
   # request will be sent to the 'go.airship.eu' server

Finally, you can change the targeted server on a request basis:

.. code-block:: ruby

   require 'urbanairship'

   Urbanairship.configure do |config|
     config.server = 'go.airship.eu'
   end

   Urbanairship::Client.new(key:'application_key', secret:'master_secret', server: 'go.urbanairship.com')
   # The Urbanairship configuration is overridden by the client and the
   # request will be sent to the 'go.urbanairship.com' server

Use Bearer Token Auth (where available)
---------------------------------------

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', token:'token')
    # If you include a token in your instantiation, the request will use token auth.
    # Token auth is required for certain endpoints, but not supported on others.

Contributing
============

1. Fork it ( https://github.com/urbanairship/ruby-library )
2. Create your feature branch: ``git checkout -b my-new-feature``
3. Commit your changes ``git commit -am 'Add some feature'``
4. Push to the branch ``git push origin my-new-feature``
5. Create a new Pull Request
6. Sign Airship's `contribution agreement
   <https://docs.google.com/forms/d/e/1FAIpQLScErfiz-fXSPpVZ9r8Di2Tr2xDFxt5MgzUel0__9vqUgvko7Q/viewform>`_.
7. Reach out to our support team at https://support.airship.com to let
us know about your PR and your urgency level.

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
