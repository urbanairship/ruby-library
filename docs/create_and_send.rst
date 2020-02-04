Create and Send
===============

The CreateAndSend class uses various notification classes as the portion of the notification
part of the payload. Different channels that harness Create and Send will require slightly different
implementation, and therefore, a different notification object.

For more context see EmailNotification and SmsNotification to see how each class method
operates, and how that is used to create the notification portion of the Create and Send payload.

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

The first few lines of code are creating a EmailNotification object, and assigning
instance variables to the object. The line of code here:
`override = email_notification.email_override`
is using a class method on EmailNotification specific for an email override in order
to format the payload correctly for the notification portion of the CreateAndSend object.

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
    send_it.notification = override
    send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send with Email Inline Template/Template ID
------------------------------------------------------

The first few lines of code are creating a EmailNotification object, and assigning
instance variables to the object. The line of code here:
`inline_template = email_notification.email_with_inline_template`
is using a class method on EmailNotification specific for an inline template. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = inline_template`

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
-------------------------------------------------

The first few lines of code are creating a EmailNotification object, and assigning
instance variables to that object. The line of code here:
`inline_template = email_notification.email_with_inline_template`
is using a class method on EmailNotification specific for an inline template. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = inline_template`

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

Create and Send to SMS Override
-------------------------------

The first few lines of code are creating a SmsNotification object, and assigning
instance variables to that object. The line of code here:
`override = notification.sms_notification_override`
is using a class method on SmsNotification specific for a sms override. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = inline_template`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
  notification = UA::SmsNotification.new(client: airship)
  notification.sms_alert = "A shorter alert with a link for SMS users to click https://www.mysite.com/amazingly/long/url-that-takes-up-lots-of-characters"
  notification.generic_alert = "A generic alert sent to all platforms without overrides in device_types"
  notification.expiry = 172800
  notification.shorten_links = true
  override = notification.sms_notification_override
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
      "ua_msisdn": "15558675309",
      "ua_sender": "12345",
      "ua_opted_in": "2018-11-11T18:45:30"
    }
  ]
  send_it.device_types = [ "sms" ]
  send_it.notification = override
  send_it.campaigns = ["winter sale", "west coast"]
  send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send to SMS With Inline Template
-------------------------------------------

The first few lines of code are creating a SmsNotification object, and assigning
instance variables to that object. The line of code here:
`template = notification.sms_inline_template`
is using a class method on SmsNotification specific for a sms inline template. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = template`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
  notification = UA::SmsNotification.new(client: airship)
  notification.sms_alert = "Hi, {{customer.first_name}}, your {{#each cart}}{{this.name}}{{/each}} are ready to pickup at our {{customer.location}} location!"
  notification.expiry = 172800
  notification.shorten_links = true
  template = notification.sms_inline_template
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
    "ua_msisdn": "15558675309",
    "ua_sender": "12345",
    "ua_opted_in": "2018-11-11T18:45:30",
      "customer": {
          "first_name": "Customer Name",
          "last_name": "Last Name",
          "location": "Location",
      },
      "cart": [
        {
          "name": "Robot Unicorn",
          "qty": 1
        },
        {
          "name": "Holy Hand Grenade of Antioch",
          "qty": 1
        }
      ]
    }
  ]
  send_it.device_types = [ "sms" ]
  send_it.notification = template
  send_it.campaigns = [ "order-pickup" ]
  send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send to SMS With Template ID
---------------------------------------

The first few lines of code are creating a SmsNotification object, and assigning
instance variables to that object. The line of code here:
`template = notification.sms_inline_template`
is using a class method on SmsNotification specific for a sms template ID. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = template`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
  notification = UA::SmsNotification.new(client: airship)
  notification.template_id = <sms_template_id_for_app>
  notification.expiry = 172800
  notification.shorten_links = true
  template = notification.sms_inline_template
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
    "ua_msisdn": "15558675309",
    "ua_sender": "12345",
    "ua_opted_in": "2018-11-11T18:45:30",
      "customer": {
          "first_name": "Customer Name",
          "last_name": "Last Name",
          "location": "Your Location",
      },
      "cart": [
        {
          "name": "Robot Unicorn",
          "qty": 1
        },
        {
          "name": "Holy Hand Grenade of Antioch",
          "qty": 1
        }
      ]
    }
  ]
  send_it.device_types = [ "sms" ]
  send_it.notification = template
  send_it.campaigns = [ "order-pickup" ]
  send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send to MMS Channels
================================

Create and Send to MMS Override
-------------------------------

The first few lines of code are creating a MmsNotification object, and assigning
instance variables to that object. The line of code here:
`mms_notification = override.mms_override`
is using a class method on MmsNotification specific for a sms template ID. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = mms_notification`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
  override = UA::MmsNotification.new(client: airship)
  override.fallback_text = "See https://urbanairship.com for double rainbows!"
  override.shorten_links = true
  override.content_length = 238686
  override.content_type = "image/jpeg"
  override.url = "https://www.metoffice.gov.uk/binaries/content/gallery/mohippo/images/learning/learn-about-the-weather/rainbows/full_featured_double_rainbow_at_savonlinna_1000px.jpg"
  override.text = "A double rainbow is a wonderful sight where you get two spectacular natural displays for the price of one."
  override.subject = "Double Rainbows"
  mms_notification = override.mms_override
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
    "ua_msisdn": "15558675309",
    "ua_sender": "12345",
    "ua_opted_in": "2018-11-11T18:45:30",
    }
  ]
  send_it.device_types = [ "mms" ]
  send_it.notification = mms_notification
  send_it.campaigns = ["winter sale", "west coast"]
  send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.

Create and Send to MMS Template with ID
---------------------------------------

The first few lines of code are creating a MmsNotification object, and assigning
instance variables to that object. The line of code here:
`mms_notification = override.mms_template_with_id`
is using a class method on MmsNotification specific for a sms template ID. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = mms_notification`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
  override = UA::MmsNotification.new(client: airship)
  override.template_id = "<existing_template_id>"
  override.shorten_links = true
  override.content_length = 19309
  override.content_type = "image/jpeg"
  override.url = "https://images-na.ssl-images-amazon.com/images/I/71eUHxwlMKL._AC_SX425_.jpg"
  mms_notification = override.mms_template_with_id
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
    "ua_msisdn": "123456789",
    "ua_sender": "12345",
    "ua_opted_in": "2020-01-30T18:45:30",
    "customer": {
              "first_name": "Phil",
              "last_name": "Leash",
          }
    }
  ]
  send_it.device_types = [ "mms" ]
  send_it.notification = mms_notification
  send_it.create_and_send


.. note::

  Should return a 202 Accepted HTTP response.

Create and Send to MMS with Inline Template
---------------------------------------

The first few lines of code are creating a MmsNotification object, and assigning
instance variables to that object. The line of code here:
`mms_notification = override.mms_inline_template`
is using a class method on MmsNotification specific for a sms template ID. This goes
on to format the payload correctly for the notification portion of the CreateAndSend object
shown in the line of code here:
`send_it.notification = mms_notification`

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<master_secret>')
  override = UA::MmsNotification.new(client: airship)
  override.subject = "Subject"
  override.fallback_text = "Fallback text"
  override.text = "Some slide text"
  override.content_length = 123100
  override.content_type = "image/jpeg"
  override.url = 'image ending in allowed image types'
  mms_notification = override.mms_inline_template
  send_it = UA::CreateAndSend.new(client: airship)
  send_it.addresses = [
    {
    "ua_msisdn": "123456789",
    "ua_sender": "12345",
    "ua_opted_in": "2020-01-30T18:45:30"
    }
  ]
  send_it.device_types = [ "mms" ]
  send_it.notification = mms_notification
  send_it.create_and_send

.. note::

  Should return a 202 Accepted HTTP response.
