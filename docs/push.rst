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
combined with ``and``, ``or``, and ``not``.


Select all to do a broadcast.

.. code-block:: ruby

    push.audience = UA.all

Select a single iOS Channel:

.. code-block:: ruby

    push.audience = UA.ios_channel(uuid)

Select a single Android Channel:

.. code-block:: ruby

    push.audience = UA.android_channel(uuid)

Select a single Amazon Channel:

.. code-block:: ruby

    push.audience = UA.amazon_channel(uuid)

Select a single iOS device token:

.. code-block:: ruby

    push.audience = UA.device_token(token)

Select a single Android APID:

.. code-block:: ruby

    push.audience = UA.apid(uuid)

Select a single Windows 8 APID:

.. code-block:: ruby

    push.audience = UA.wns(uuid)

Select a single tag:

.. code-block:: ruby

    push.audience = UA.tag(tag)

Select a single tag with a specified tag group (Note: defaults to ``device`` tag group when one is not provided):

.. code-block:: ruby

    push.audience = UA.tag(tag, group:'tag-group')

Select a single alias:

.. code-block:: ruby

    push.audience = UA.alias(alias)

Select a single segment:

.. code-block:: ruby

    push.audience = UA.segment(segment)

Select a single named user:

.. code-block:: ruby

    push.audience = UA.named_user(named_user)

Select devices that match at least one of the given selectors:

.. code-block:: ruby

    push.audience = UA.or(UA.tag('sports'), UA.tag('business'))

Select devices that match all of the given selectors:

.. code-block:: ruby

    push.audience = UA.and(UA.tag('sports'), UA.tag('business'))

Select devices that do not match the given selectors:

.. code-block:: ruby

    push.audience = UA.not(UA.and(UA.tag('sports'), UA.tag('business')))

Select a location expression. Location selectors are made up of either an id or
an alias and a date period specifier. Use a date specification function to
generate the time period specifier. Location aliases can be found here:
http://docs.urbanairship.com/reference/location_boundary_catalog.html

ID location example:

.. code-block:: ruby

    push.audience = UA.location(
        id: 'location_id',
        date: UA.recent_date(days: 4)
    )

Alias location example:

.. code-block:: ruby

    push.audience = UA.location(
        us_zip: 12345,
        date: UA.recent_date(days: 4)
    )

Select a recent date range for a location selector.
Valid selectors are: hours ,days, weeks, months, years

.. code-block:: ruby

    recent_date(months: 6)
    recent_date(weeks: 3)

Select an absolute date range for a location selector. Parameters are resolution,
start, and the_end. Resolutions is one of :hours, :days, :weeks, :months, or :years.
Start and the_end are UTC times in ISO 8601 format.

.. code-block:: ruby

    absolute_date(
        resolution: months,
        start: '2013-01', the_end: '2013-06'
    )

    absolute_date(
        resolution: :hours,
        start: '2012-01-01 11:00',
        the_end: '2012-01-01 12:00')
    )

Notification Payload
--------------------

The notification payload determines what message and data is sent to a
device. At its simplest, it consists of a single string-valued
attribute, "alert", which sends a push notification consisting of a
single piece of text:

.. code-block:: ruby

    push.notification = UA.notification(alert: "Hello, world!")

You can override the notification payload with one of the following platform
keys::

   ios, amazon, android, wns

In the examples below, we override the general ``'Hello World!'`` alert with
platform-specific alerts, and we set a number of other platform-specific options.

**Example iOS Override**

.. code-block:: ruby

    push.notification = UA.notification(
        alert: 'Hello World!',
        ios: UA.ios(
            alert: 'Hello iOS!',
            badge: 123,
            sound: 'sound file',
            extra: { 'key' => 'value', 'key2' => 'value2' }
            expiry: '2012-01-01 12:45',
            category: 'category_name',
            interactive: UA.interactive(
                type: 'ua_share',
                button_actions: {
                    share: { share: 'Sharing is caring!' }
                }
            ),
            content_available: true
        )
    )

**Example Amazon Override**

.. code-block:: ruby

    push.notification = UA.notification(
        alert: 'Hello World!',
        amazon: UA.amazon(
            alert: 'Hello Amazon!',
            consolidation_key: 'key',
            expires_after: '2012-01-01 12:45',
            extra: { 'key' => 'value', 'key2' => 'value2' },
            title: 'title',
            summary: 'summary',
            interactive: UA.interactive(
                type: 'ua_share',
                button_actions: {
                    share: { share: 'Sharing is caring!' }
                }
            )
        )
    )

**Example Android Override**

.. code-block:: ruby

    push.notification = UA.notification(
        alert: 'Hello World!',
        android: UA.android(
            alert: 'Hello Android!',
            collapse_key: 'key',
            time_to_live: 123,
            extra: { 'key' => 'value', 'key2' => 'value2' },
            delay_while_idle: false,
            interactive: UA.interactive(
                type: 'ua_share',
                button_actions: {
                    share: { share: 'Sharing is caring!' }
                }
            )
        )
    )

**Example WNS Override**

.. code-block:: ruby

    push.notification = UA.notification(
        alert: 'Hello World!',
        wns: UA.wns_payload(
            alert: 'Hello WNS!',
            tile: nil,
            toast: nil,
            badge: nil
        )
    )


.. note::
    The input for wns_payload must include exactly one of
    alert, toast, tile, or badge.


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


Interactive Notifications
-------------------------

The interactive notification payload determines the ways you can interact
with a notification. It contains two attributes: "type" (mandatory) and
"button_actions" (optional). More information at
http://docs.urbanairship.com/api/ua.html#interactive-notifications
Example:

.. code-block:: ruby

    push.notification = UA.notification(
        alert: "Hello, world!",
        interactive: UA.interactive(
            type: "ua_share",
            button_actions: {
                share: {share: "Sharing is caring!"}
            }
        )
    )

Button actions can also be mapped to *actions* objects as shown below:

.. code-block:: ruby

    shared = ua.actions(share: "Sharing is caring!")
    push.notification = ua.notification(
        alert: "Hello, world!",
        interactive: ua.interactive(
            type: "ua_share",
            button_actions: {
                    "share" : shared
            }
        )
    )


Device Types
------------

In addition to specifying the audience, you must specify the device
types you wish to target with a list of strings:

.. code-block:: ruby

    push.device_types = UA.device_types(['ios', 'android'])

or with the ``all`` shortcut.

.. code-block:: ruby

    push.device_types = UA.all


Delivery
--------

Once you have set the ``audience``, ``notification``, and ``device_types``
attributes, the notification is ready for delivery.

.. code-block:: ruby

    push.send_push

If the delivery is unsuccessful, an :rb:class:`AirshipFailure` exception
will be raised.


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


Updating or Canceling a Schedule
--------------------------------

If you have the ``schedule_url`` returned from creating a scheduled
notification, you can update or cancel it before it's sent.

.. code-block:: ruby

   schedule = UA::ScheduledPush.from_url(client: airship, url: 'url')
   # change scheduled time to tomorrow
   schedule.schedule = UA.scheduled_time(Time.now.utc + (60 * 60 * 24))
   schedule.update

   # Cancel
   schedule.cancel


Listing a Particular Schedule
-----------------------------

If you have the schedule id, you can use it to list the details of a
particular schedule.

.. code-block:: ruby

    airship = UA::Client.new(key: '123', secret: 'abc')
    scheduled_push = UA::ScheduledPush.new(airship)
    schedule_details = scheduled_push.list(schedule_id: 'id')
    puts(schedule_details)

.. note::
    The schedule_id can be obtained from the url of the schedule.


Listing all Schedules
---------------------

You can list all schedules with the ``ScheduledPushList`` class:

.. code-block:: ruby

    airship = UA::Client.new(key: '123', secret: 'abc')
    scheduled_push_list = UA::ScheduledPushList.new(client: airship)
    scheduled_push_list.each do |schedule|
        puts(schedule)
    end
