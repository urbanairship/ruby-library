Email
=====

Register Email Channel
----------------------

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    email_channel = UA::Email.new(client: airship)
    email_channel.type = 'email'
    email_channel.commercial_opted_in = '2018-10-28T10:34:22'
    email_channel.address = 'finnthehuman@adventure.com'
    email_channel.timezone = 'America/Los_Angeles'
    email_channel.locale_country = 'US'
    email_channel.locale_language = 'en'
    email_channel.register

.. note::

  The registration of an email channel should yield a 201 response. The address
  portion must be defined with an email address to register an email channel.
  There are a few more fields listed on the email object that can be set as well
  such as transactional_opted_in.

Email Tags
----------

Using the Email Tag class inheriting from Channel Tags, tags can be added,
removed, or set for a single email channel.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    email_tags = UA::EmailTags.new(client: airship)
    #set an audience
    email_tags.set_audience(email_address: 'finnthehuman@adventure.com')
    #add a tag
    email_tags.add(group_name: :group_name, tags: :tag1)
    #remove a tag
    email_tags.remove(group_name: :group_name, tags: :tag1)
    #set a tag
    email_tags.set(group_name: :group_name, tags: :tag1)
    #finally, send the request
    email_tags.send_request

.. note::

  The code-block above can be used to set, add, or remove tags depending on the
  needs of the request. It should be noted that add and set functionality cannot
  be used simultaneously, as well as remove and set. Conversely, add and remove
  can be used in the same request.

Uninstall Email Channel
-----------------------

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    email_channel = UA::Email.new(client: airship)
    email_channel.address = 'finnthehuman@adventure.com'
    email_channel.uninstall

.. note::
