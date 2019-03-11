SMS Channel
===========

Register SMS Channel
--------------------

SMS channels need a sender, and msisdn, upon registration. The opted_in value
is optional. The following is an example of a request with an opted_in value.


.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    sms_channel = UA::Sms.new(client: airship)
    sms_channel.msisdn = '15035556789'
    sms_channel.sender = '12345'
    sms_channel.opted_in = '2018-02-13T11:58:59'
    sms_channel.register()

Opt-Out of SMS Messages
-----------------------

Uninstall SMS Channel
---------------------

SMS Channel Lookup
------------------
