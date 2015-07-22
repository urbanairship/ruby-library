Defining and Sending Push Notifications
=======================================

The Urban Airship Python Library strives to match the standard Urban
Airship JSON format for specifying push notifications. When creating a
push notification, you:

#. Select the audience
#. Define the notification payload
#. Specify device types.
#. Deliver the notification.

This example performs a broadcast with the same alert to all recipients
and device types:

.. code-block:: python

   import urbanairship as ua
   airship = ua.Airship(app_key, master_secret)

   push = airship.create_push()
   push.audience = ua.all_
   push.notification = ua.notification(alert="Hello, world!")
   push.device_types = ua.all_
   push.send()


Audience Selectors
------------------

An audience should specify one or more devices. An audience can be a
device, such as a ``channel``, ``device_token`` or ``apid``; a tag,
alias, or segment; a location; or a combination. Audience selectors are
combined with ``and_``, ``or_``, and ``not_``.

.. py:data:: urbanairship.push.all_

   Select all, to do a broadcast.

   Used in both ``audience`` and ``device_types``.

   .. code-block:: python

      push.audience = ua.all_


.. automodule:: urbanairship.push.audience
   :members:
   :noindex:


Notification Payload
--------------------

The notification payload determines what message and data is sent to a
device. At its simplest, it consists of a single string-valued
attribute, "alert", which sends a push notification consisting of a
single piece of text:

.. code-block:: python

   push.notification = ua.notification(alert="Hello, world!")

You can override the payload with platform-specific values as well.

.. automodule:: urbanairship.push.payload
   :members: notification, ios, android, blackberry, wns_payload, mpns_payload


Actions
-------

Urban Airship Actions provides a convenient way to automatically
perform tasks by name in response to push notifications,
Rich App Page interactions and JavaScript. More information at
http://docs.urbanairship.com/api/ua.html#actions, example:

.. code-block:: python

   push.notification = ua.notification(
          alert="Hello, world!",
          actions=ua.actions(
              add_tag="new_tag",
              remove_tag="old_tag",
              share="Check out Urban Airship!",
              open_={
                  "type": "url",
                  "content": "http://www.urbanairship.com"
              },
              app_defined={
                  "some_app_defined_action": "some_values"
              }
          )
   )

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

.. code-block:: python

    push.notification = ua.notification(
        alert="Hello, world!",
        interactive=ua.interactive(
            type = "ua_share",
            button_actions = {
                    "share" : { "share" : "Sharing is caring!"}
            }
        )
    )

Button actions can also be mapped to *actions* objects as shown below:

.. code-block:: python

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

.. code-block:: python

   push.device_types = ua.device_types('ios', 'blackberry')

or with the ``all_`` shortcut.

.. code-block:: python

   push.device_types = ua.all_

.. autofunction:: urbanairship.push.payload.device_types


Delivery
--------

Once you have set the ``audience``, ``notification``, and ``device_types``
attributes, the notification is ready for delivery.

.. code-block:: python

   push.send()

If the delivery is unsuccessful, an :py:class:`AirshipFailure` exception
will be raised.

.. autoclass:: urbanairship.push.core.Push
   :members:


Scheduled Delivery
------------------

Scheduled notifications build upon the Push object, and have two other
components: the scheduled time(s) and an optional name.

This example schedules the above notification for delivery in one
minute.

.. code-block:: python

   import datetime

   schedule = airship.create_scheduled_push()
   schedule.push = push
   schedule.name = "optional name for later reference"
   schedule.schedule = ua.scheduled_time(
       datetime.datetime.utcnow() + datetime.timedelta(minutes=1))
   response = schedule.send()

   print ("Created schedule. url:", response.schedule_url)

If the schedule is unsuccessful, an :py:class:`AirshipFailure`
exception will be raised.

.. autoclass:: urbanairship.push.core.ScheduledPush
   :members:


Scheduled Delivery in Device Local Time
---------------------------------------

Scheduled notifications build upon the Push object, and have two other
components: the scheduled time(s) and an optional name.

This example schedules the above notification for delivery in device
local time.

.. code-block:: python

   import datetime

   schedule = airship.create_scheduled_push()
   schedule.push = push
   schedule.name = "optional name for later reference"
   schedule.schedule = ua.local_scheduled_time(
       datetime.datetime(2015, 4, 1, 8, 5))
   response = schedule.send()

   print ("Created schedule. url:", response.schedule_url)

If the schedule is unsuccessful, an :py:class:`AirshipFailure` exception
will be raised.

.. autoclass:: urbanairship.push.core.ScheduledPush
   :members:


Updating or Canceling a Schedule
--------------------------------

If you have the ``schedule_url`` returned from creating a scheduled
notification, you can update or cancel it before it's sent.

.. code-block:: python

   schedule = ua.ScheduledPush.from_url(airship, url)
   # change scheduled time to tomorrow
   schedule.schedule = ua.scheduled_time(
       datetime.datetime.utcnow() + datetime.timedelta(days=1))
   schedule.update()

   # Cancel
   schedule.cancel()
