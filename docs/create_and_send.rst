Create and Send
===============

The Ruby Library uses different kinds of objects in addition to the CreateAndSend object.
Different ways to use Create and Send will require slightly different implementation, and
therefore, a different object.

For background information visit out docs here: https://docs.airship.com/api/ua/#tag/create-and-send

Create and Send Validation
--------------------------

Here, the payload that is being validated is one that would be used for email override.
However, this validation method should work on any other create and send notification objects.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    email_notification = UA::EmailNotification.new(client: airship)
    email_notification.bypass_opt_in_level = false
    email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
    email_notification.message_type = 'transactional'
    email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
    email_notification.reply_to = '<reply_to address>'
    email_notification.sender_address = '<sender_address>'
    email_notification.sender_name = 'Sender Name'
    email_notification.subject = 'Subject Line'
    override = email_notification.email_override
    send_it = UA::CreateAndSend.new(client: airship)
    send_it.addresses = [
      {
        "ua_address": "test@example.com",
        "ua_commercial_opted_in": "2019-12-29T10:34:22"
      }
    ]
    send_it.device_types = [ "email" ]
    send_it.campaigns = ["winter sale", "west coast"]
    send_it.notification = email_notification.email_override
    send_it.validate

.. note::

  Should return a 200 HTTP status code.

Schedule Create and Send Operation
----------------------------------

Here, the payload that is being scheduled is one that would be used for email override.
However, this operation method should schedule any other create and send notification objects.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    email_notification = UA::EmailNotification.new(client: airship)
    email_notification.bypass_opt_in_level = false
    email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
    email_notification.message_type = 'transactional'
    email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
    email_notification.reply_to = '<reply_to address>'
    email_notification.sender_address = '<sender_address>'
    email_notification.sender_name = 'Sender Name'
    email_notification.subject = 'Subject Line'
    override = email_notification.email_override
    send_it = UA::CreateAndSend.new(client: airship)
    send_it.addresses = [
      {
        "ua_address": "test@example.com",
        "ua_commercial_opted_in": "2019-12-29T10:34:22"
      }
    ]
    send_it.device_types = [ "email" ]
    send_it.campaigns = ["winter sale", "west coast"]
    send_it.notification = email_notification.email_override
    send_it.name = 'Name for scheduled create and send'
    send_it.scheduled_time =  "2019-13-29T10:34:22"
    send_it.schedule

.. note::

  Should return a 201  HTTP status code.

Create and Send to Email Channels
=================================

You will need to create an EmailNotification object before adding that to the notification
field as the create and send object.

Create and Send with Email Override
-----------------------------------

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    email_notification = UA::EmailNotification.new(client: airship)
    email_notification.bypass_opt_in_level = false
    email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
    email_notification.message_type = 'transactional'
    email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
    email_notification.reply_to = '<reply_to address>'
    email_notification.sender_address = '<sender_address>'
    email_notification.sender_name = 'Sender Name'
    email_notification.subject = 'Subject Line'
    override = email_notification.email_override
    send_it = UA::CreateAndSend.new(client: airship)
    send_it.addresses = [
      {
        "ua_address": "test@example.com",
        "ua_commercial_opted_in": "2019-12-29T10:34:22"
      }
    ]
    send_it.device_types = [ "email" ]
    send_it.campaigns = ["winter sale", "west coast"]
    send_it.notification = email_notification.email_override
    send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send with Email Inline Template/Template ID
------------------------------------------------------

.. code-block:: ruby

require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.message_type = 'transactional'
email_notification.reply_to = 'reply_to_this@email.com'
email_notification.sender_address = 'sends_from_this@email.com'
email_notification.sender_name = 'Sender Name'
email_notification.template_id = "<template_id>"
inline_template = email_notification.email_with_inline_template
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_address": "test@example.com",
    "ua_commercial_opted_in": "2019-12-29T10:34:22"
  }
]
send_it.device_types = [ "email" ]
send_it.campaigns = ["winter sale", "west coast"]
send_it.notification = inline_template
send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send with Email Inline Template/Fields
------------------------------------------------------

.. code-block:: ruby

require 'urbanairship'
UA = Urbanairship
airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
email_notification = UA::EmailNotification.new(client: airship)
email_notification.message_type = 'transactional'
email_notification.reply_to = 'reply_to_this@email.com'
email_notification.sender_address = 'sends_from_this@email.com'
email_notification.sender_name = 'Sender Name''
email_notification.subject= "I'm sending some stuff"
email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
inline_template = email_notification.email_with_inline_template
send_it = UA::CreateAndSend.new(client: airship)
send_it.addresses = [
  {
    "ua_address": "example@test.com",
    "ua_commercial_opted_in": "2019-12-29T10:34:22"
  }
]
send_it.device_types = [ "email" ]
send_it.campaigns = ["winter sale", "west coast"]
send_it.notification = inline_template
send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

  Create and Send to SMS Channels
  ================================
