SMS Channel
===========

Register SMS Channel
--------------------

SMS channels need a sender, and MSISDN, upon registration. The opted_in key
is optional. The opted_in key represents the time when explicit permission was received from the user to receive messages. The following is an example of a request with an opted_in key.


.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    sms_channel = UA::Sms.new(client: airship)
    sms_channel.msisdn = '15035556789'
    sms_channel.sender = '12345'
    sms_channel.opted_in = '2018-02-13T11:58:59'
    sms_channel.register

Opt-Out of SMS Messages
-----------------------

Opting out of SMS messaging requires a sender and a MSISDN to be set.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    sms_channel = UA::Sms.new(client: airship)
    sms_channel.msisdn = '15035556789'
    sms_channel.sender = '12345'
    sms_channel.opt_out

Uninstall SMS Channel
---------------------

Uninstalling SMS messaging requires a sender and a MSISDN to be set.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    sms_channel = UA::Sms.new(client: airship)
    sms_channel.msisdn = '15035556789'
    sms_channel.sender = '12345'
    sms_channel.uninstall

SMS Channel Lookup
------------------

Looking up an SMS channel requires a sender and an MSISDN to be set.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    sms_channel = UA::Sms.new(client: airship)
    sms_channel.msisdn = '15035556789'
    sms_channel.sender = '12345'
    sms_channel.lookup
