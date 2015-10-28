Urban Airship Ruby Library
==========================

``urbanairship`` is a Ruby library for using the `Urban Airship
<http://urbanairship.com/>`_ web service API for push notifications and
rich app pages.


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
:rb:class:`Airship` object representing a single UA application.

Note that channels are preferred over ``device_token`` and ``apid``. See:
`documentation on channels <channels>`_.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = UA.all
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.all
    p.send_push

The library uses `unirest`_ for communication with the UA API.


Development
-----------

The library source code is `available on GitHub <github>`_.

Tests can be run with rspec_:

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
   automation.rst
   feeds.rst
   exceptions.rst
   examples.rst


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


.. _channels: http://docs.urbanairship.com/topic-guides/channels.html
.. _unirest: http://unirest.io/ruby.html
.. _github: https://github.com/urbanairship/ruby-library
.. _rspec: https://nose.readthedocs.org/en/latest/
