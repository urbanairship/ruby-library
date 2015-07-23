Defining and Sending Push Notifications
=======================================

The Urban Airship Ruby Library strives to match the standard Urban
Airship JSON format for specifying push notifications. When creating a
push notification, you:

#. Select the audience
#. Define the notification payload
#. Specify device types.
#. Deliver the notification.

This example performs a broadcast with the same alert to all recipients
and device types:

.. code-block:: ruby

    require 'urbanairship'

    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    push = airship.create_push
    push.audience = UA.all
    push.notification = UA.notification(alert: 'Hello')
    push.device_types = UA.all
    push.send_push


Audience Selectors
------------------

An audience should specify one or more devices. An audience can be a
device, such as a ``channel``, ``device_token`` or ``apid``; a tag,
alias, or segment; a location; or a combination. Audience selectors are
combined with ``and_``, ``or_``, and ``not_``.

.. rb:data:: urbanairship.push.all_

   Select all, to do a broadcast.

   Used in both ``audience`` and ``device_types``.

   .. code-block:: ruby

      push.audience = UA.all


.. automodule:: urbanairship.push.audience
   :members:
   :noindex:


Notification Payload
--------------------

The notification payload determines what message and data is sent to a
device. At its simplest, it consists of a single string-valued
attribute, "alert", which sends a push notification consisting of a
single piece of text:

.. code-block:: ruby

   push.notification = UA.notification(alert="Hello, world!")

You can override the payload with platform-specific values as well.

.. automodule:: urbanairship.push.payload
   :members: notification, ios, android, blackberry, wns_payload, mpns_payload


Actions
-------

Urban Airship Actions provides a convenient way to automatically
perform tasks by name in response to push notifications,
Rich App Page interactions and JavaScript. More information at
http://docs.urbanairship.com/api/ua.html#actions, example:

.. code-block:: ruby

   push.notification = UA.notification(
    alert: 'Hello world',
    actions: UA.actions(
        add_tag: 'new_tag',
        remove_old: 'old_tag',
        share: 'Check out Urban Airship!',
        open_: {
            type: 'url',
            content: 'http://www.urbanairship.com'
        },
        app_defined: {
            some_app_defined_action: 'some_values'
        },
    ))

.. automodule:: urbanairship.push.payload
   :members: notification, actions, ios, android, amazon
   :noindex:

Interactive Notifications
-------------------------

The interactive notification payload determines the ways you can interact
with a notification. It contains two attributes: "type" (mandatory) and
"button_actions" (optional). More information at
http://docs.urbanairship.com/api/ua.html#interactive-notifications
Example:

.. code-block:: ruby

    push.notification = UA.notification(
        alert="Hello, world!",
        interactive=UA.interactive(
            type = "ua_share",
            button_actions = {
                share: {share: "Sharing is caring!"}
            }
        )
    )

Button actions can also be mapped to *actions* objects as shown below:

.. code-block:: ruby

    shared = ua.actions(share="Sharing is caring!")
    push.notification = ua.notification(
        alert="Hello, world!",
        interactive=ua.interactive(
            type = "ua_share",
            button_actions = {
                    "share" : shared
            }
        )
    )

.. automodule:: urbanairship.push.payload
   :members: notification, interactive
   :noindex:


Device Types
------------

In addition to specifying the audience, you must specify the device
types you wish to target, either with a list of strings:

.. code-block:: ruby

   push.device_types = UA.device_types('ios', 'blackberry')

or with the ``all_`` shortcut.

.. code-block:: ruby

   push.device_types = UA.all_

.. autofunction:: urbanairship.push.payload.device_types


Delivery
--------

Once you have set the ``audience``, ``notification``, and ``device_types``
attributes, the notification is ready for delivery.

.. code-block:: ruby

   push.send_push

If the delivery is unsuccessful, an :rb:class:`AirshipFailure` exception
will be raised.

.. autoclass:: urbanairship.push.Push
   :members:


Scheduled Delivery
------------------

Scheduled notifications build upon the Push object, and have two other
components: the scheduled time(s) and an optional name.

This example schedules the above notification for delivery in one
minute.

.. code-block:: ruby

    schedule = airship.create_scheduled_push
    schedule.push = push
    schedule.name = "optional name for later reference"
    schedule.schedule = UA.scheduled_time(Time.now.utc + 60)
    response = schedule.send_push
    print ("Created schedule. url: " + response.schedule_url)

If the schedule is unsuccessful, an :rb:class:`AirshipFailure`
exception will be raised.

.. autoclass:: urbanairship.push.ScheduledPush
   :members:


Scheduled Delivery in Device Local Time
---------------------------------------

Scheduled notifications build upon the Push object, and have two other
components: the scheduled time(s) and an optional name.

This example schedules the above notification for delivery in device
local time.

.. code-block:: ruby

    schedule = airship.create_scheduled_push
    schedule.push = push
    schedule.name = "optional name for later reference"
    schedule.schedule = UA.local_scheduled_time(Time.now + 60)
    response = schedule.send_push
    print ("Created schedule. url: " + response.schedule_url)

If the schedule is unsuccessful, an :rb:class:`AirshipFailure` exception
will be raised.

.. autoclass:: urbanairship.push.ScheduledPush
   :members:


Updating or Canceling a Schedule
--------------------------------

If you have the ``schedule_url`` returned from creating a scheduled
notification, you can update or cancel it before it's sent.

.. code-block:: ruby

   schedule = UA.ScheduledPush.from_url(airship, url)
   # change scheduled time to tomorrow
   schedule.schedule = UA.scheduled_time(
       Time.now.utc + (60 * 60 * 24))
   schedule.update()

   # Cancel
   schedule.cancel()
