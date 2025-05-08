Airship Ruby Library
====================

``urbanairship`` is a Ruby library for using the `Airship
<http://airship.com/>`_ web service API for messaging.


Installation
------------

If you have the ``bundler`` gem (if not you can get it with ``$ gem install bundler``) add this line to your application's Gemfile::

    >>> gem 'urbanairship'

And then execute::

    >>> $ bundle

OR install it yourself as::

    >>> gem install urbanairship


Using the library
-----------------

The library is intended to be used with the small footprint of a single
import. To get started, import the package, and create an
``Airship`` object representing a single Airship project.

The library uses `rest-client <https://github.com/rest-client/rest-client>`_ for communication with the Airship API.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = UA.all
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.device_types(['ios','android'])
    p.send_push

We in the process of migrating code examples away from these docs and into the
regular `Airship API reference <https://docs.airship.com/api/ua/>`_ 
(select "Ruby Library"), so please check there for more examples.

Please also see `the README <https://github.com/urbanairship/ruby-library/blob/main/README.rst>`_
for detailed instructions on how to use bearer token auth and alternative servers.


Development
-----------

The library source code is `available on GitHub <https://github.com/urbanairship/ruby-library>`_.

Tests can be run with `rspec <https://rspec.info/>`_.

Contents:

.. toctree::
   :maxdepth: 2

   push.rst
   segment.rst
   devices.rst
   channel_uninstall.rst
   tags.rst
   named_user.rst
   reports.rst
   static_lists.rst
   tag_lists.rst
   exceptions.rst
   examples.rst
   create_and_send.rst
   email.rst
   open_channels.rst
   sms.rst
   automations.rst
   ab_tests.rst
   attributes.rst


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
