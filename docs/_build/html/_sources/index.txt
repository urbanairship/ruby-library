Urban Airship Python Library
============================

``urbanairship`` is a Python library for using the `Urban Airship
<http://urbanairship.com/>`_ web service API for push notifications and
rich app pages.

Installation
------------

Using ``pip``::

   $ pip install urbanairship

Using the library
-----------------

The library is intended to be used with the small footprint of a single
import. To get started, import the package, and create an
:py:class:`Airship` object representing a single UA application.

Note that channels are preferred over `device_token` and `apid`. See:
`documentation on channels <channels>`_.

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship('<app key>', '<master secret>')

   push = airship.create_push()
   push.audience = ua.ios_channel('074e84a2-9ed9-4eee-9ca4-cc597bfdbef3')
   push.notification = ua.notification(ios=ua.ios(alert='Hello from Python', badge=1))
   push.device_types = ua.device_types('ios')
   push.send()

The library uses `requests`_ for communication with the UA API,
providing connection pooling and strict SSL checking. The ``Airship``
object is threadsafe, and can be instantiated once and reused in
multiple threads.

Logging
-------

``urbanairship`` uses the standard logging module for integration into
an application's existing logging. If you do not have logging
configured otherwise, your application can set it up like so:

.. code-block:: python

   import logging
   logging.basicConfig()

If you're having trouble with the UA API, you can turn on verbose debug
logging.

.. code-block:: python

   logging.getLogger('urbanairship').setLevel(logging.DEBUG)

As of Python 2.7, ``DeprecationWarning`` warnings are silenced by
default. To enable them, use the ``warnings`` module:

.. code-block:: python

   import warnings
   warnings.simplefilter('default')

Development
-----------

The library source code is `available on GitHub <github>`_.

Tests can be run with nose_:

.. code-block:: sh

   nosetests --with-doctest

Contents:

.. toctree::
   :maxdepth: 2

   push.rst
   devices.rst
   channel_uninstall.rst
   segment.rst
   tags.rst
   reports.rst
   named_user.rst
   static_lists.rst
   exceptions.rst
   examples.rst


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


.. _channels: http://docs.urbanairship.com/topic-guides/channels.html
.. _requests: http://python-requests.org
.. _github: https://github.com/urbanairship/python-library
.. _nose: https://nose.readthedocs.org/en/latest/
