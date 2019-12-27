Create and Send
===============

The Ruby Library uses different kinds of objects in addition to the CreateAndSend object.
Different ways to use Create and Send will require slightly different implementation, and
therefore, a different object.

For background information visit out docs here: https://docs.airship.com/api/ua/#tag/create-and-send

Create and Send to Email Channels
=================================

You will need to create an EmailNotification object before adding that to the notification
field as the create and send object.

Create and Send with Email Override
-----------------------------------

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    email_notification = UA::EmailNotification.new(client: airship)
    email_notification.bcc = "example@fakeemail.com"
    email_notification.bypass_opt_in_level = false
    email_notification.html_body = "<h2>Richtext body goes here</h2><p>Wow!</p><p><a data-ua-unsubscribe=\"1\" title=\"unsubscribe\" href=\"http://unsubscribe.urbanairship.com/email/success.html\">Unsubscribe</a></p>"
    email_notification.message_type = 'commercial'
    email_notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
    email_notification.reply_to = 'another_fake_email@domain.com'
    email_notification.sender_address = 'team@urbanairship.com'
    email_notification.sender_name = 'Airship'
    email_notification.subject = 'Did you get that thing I sent you?'
    override = email_notification.email_override

    create_and_send = UA::CreateAndSend.new(client: airship)
    create_and_send.addresses = [
      {
        "ua_address": "new@email.com",
        "ua_commercial_opted_in": "2018-11-29T10:34:22",
      },
      {
        "ua_address": "ben@icetown.com",
        "ua_commercial_opted_in": "2018-11-29T12:45:10",
      }
    ]
    create_and_send.device_types = [ "email" ]
    create_and_send.campaigns = ["winter sale", "west coast"]
    create_and_send.notification = email_notification

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send with Email Inline Template
------------------------------------------

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    email_notification = UA::EmailNotification.new(client: airship)
    notification.bcc = "example@fakeemail.com"
    notification.message_type = 'commercial'
    notification.reply_to = 'another_fake_email@domain.com'
    notification.sender_address = 'team@urbanairship.com'
    notification.sender_name = 'Airship'
    notification.template_id = "9335bb2a-2a45-456c-8b53-42af7898236a"
    notification.plaintext_body = 'Plaintext version goes here [[ua-unsubscribe href=\"http://unsubscribe.urbanairship.com/email/success.html\"]]'
    notification.subject = 'Did you get that thing I sent you?'
    notification.variable_details = [
      {
          'key': 'name',
          'default_value': 'hello'
      },
      {
          'key': 'event',
          'default_value': 'event'
      }
    ]
    inline_template = notification.email_with_inline_template

    create_and_send = UA::CreateAndSend.new(client: airship)
    create_and_send.device_types = [ "email" ]
    create_and_send.addresses = [
      {
        "ua_address": "new@email.com",
        "ua_commercial_opted_in": "2018-11-29T10:34:22",
      },
      {
        "ua_address": "ben@icetown.com",
        "ua_commercial_opted_in": "2018-11-29T12:45:10",
      }
    ]
    create_and_send.campaigns = ["winter sale", "west coast"]
    create_and_send.notification = inline_template

.. note::

  Should return a 202 Accepted HTTP response.
