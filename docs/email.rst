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
