Attributes
==========

Set Attribute for a Channel
---------------------------

The following will set an attribute for a given channel ID.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'app_key', secret:'secret_key')
    channel_info = UA::ChannelInfo.new(client: airship)
    channel_info.audience = {"ios_channel": "b8f9b663-0a3b-cf45-587a-be880946e881"}
    channel_info.attributes =  {
        "action": "set",
        "key": "favorite_food",
        "value": "cake"
    }
    channel_info.set_attributes

.. note::

    This should return a 200 response

Set or Remove Attributes for a Named User
-----------------------------------------

The following example shows you how to set and remove attributes on a given named user.
    
.. code-block:: ruby
    
    require 'urbanairship'
    airship = Urbanairship::Client.new(key: 'application_key', secret: 'master_secret')
    named_user = Urbanairship::NamedUser.new(client: airship)
    named_user.named_user_id = 'named_user'
    named_user.update_attributes(attributes: [
        { action: 'set', key: 'first_name', value: 'Firstname' },
        { action: 'remove', key: 'nickname' },
        { action: 'set', key: 'last_name', value: 'Lastname', timestamp: Time.now.utc }
    ])
    
.. note::

    Timestamp is optional, if missing it will default to 'now'

Send Push to Audience with Attribute Specifications
---------------------------------------------------

This will send a push to an audience who meet the specifications of attribute we
set here. This example is using a text attribute where we are looking for audience
members whose favorite food includes 'apple'. Some examples of what this could return
would be 'apple', 'pineapple',  or 'apple pie'. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'app_key', secret:'secret_key')
    new_attribute = UA::Attribute.new(client: airship)
    new_attribute.attribute = 'favorite_food'
    new_attribute.operator = 'contains'
    new_attribute.value = 'apple'
    push = airship.create_push
    push.audience = new_attribute.payload
    push.notification = UA.notification(alert: 'Hello')
    push.device_types = ['android', 'ios', 'web']
    push.send_push

.. note::

    This should return a 202 response