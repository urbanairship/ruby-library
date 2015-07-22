Static Lists
============

With the Static List endpoint, you can easily target and manage
lists of devices that are defined in your systems outside of Urban Airship.
Any list or grouping of devices for which the canonical source of data about
the members is elsewhere is a good candidate for Static Lists, e.g., members
of a customer loyalty program.
For more information, see: http://docs.urbanairship.com/api/ua.html#static-lists


Create List
-----------
Creates a static list. The body of the request will contain several of the list
object parameters, but the actual list content will be provided by a second call
to the upload endpoint.

The create method has two optional parameters including 'description,' which is a
user-provided description of the list, and 'extras,' which is a dictionary of
string keys to arbitrary JSON values.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticList(airship, 'list_name')
    static_list.create('description', 'extras')

.. automodule:: urbanairship.devices.static_lists
    :members: StaticList
    :noindex:


Upload List
-----------
Lists target identifiers are specified or replaced with an upload to this endpoint.
Uploads must be newline delimited identifiers (text/CSV) as described in RFC 4180,
with commas as the delimiter.

The CSV format consists of two columns: 'identifier_type' and 'identifier'.
'identifier_type' must be one of 'alias', 'named_user', 'ios_channel', 'android_channel',
or 'amazon_channel'. 'identifier' is the associated identifier you wish to send to.

The maximum number of 'identifier_type,identifier' pairs that may be uploaded to a list
is 10 million. The csv file is automatically gzipped before it is uploaded to the
endpoint.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticList(airship, 'list_name')
    csv_file = open(path, 'rb')
    resp = static_list.upload(csv_file)
    csv_file.close()

.. automodule:: urbanairship.devices.static_lists
    :members: StaticList
    :noindex:


Update List
-----------
Updates the metadata of a static list.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticList(airship, 'list_name')
    static_list.update('description', 'extras')

.. automodule:: urbanairship.devices.static_lists
    :members: StaticList
    :noindex:


Delete List
-----------
Delete a static list.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticList(airship, 'list_name')
    static_list.delete()

.. automodule:: urbanairship.devices.static_lists
    :members: StaticList
    :noindex:

.. note::
    If you are attempting to update a current list by deleting it
    and then recreating it with new data, stop and go to the upload
    endpoint. There is no need to delete a list before uploading a
    new CSV file. Moreover, once you delete a list, you will be unable
    to create a list with the same name as the deleted list.


Lookup List
-----------
Retrieve information about one static list.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticList(airship, 'list_name')
    static_list.lookup()

.. automodule:: urbanairship.devices.static_lists
    :members: StaticList

.. note::
    When looking up lists, the returned information may actually be a combination
    of values from both the last uploaded list and the last successfully processed
    list. If you create a list successfully, and then you update it and the
    processing step fails, then the list status will read "failed", but the
    channel_count and last_modified fields will contain information on the last
    successfully processed list.


Lookup All Lists
----------------
Retrieve information about all static lists. This call returns a paginated list of
metadata that will not contain the actual lists of users.

.. code-block:: python

    airship = ua.Airship('app_key', 'master_secret')
    static_list = ua.devices.StaticLists(airship)

    for resp in static_list:
        print(
            resp.name,
            resp.description,
            resp.extra,
            resp.created,
            resp.last_modified,
            resp.channel_count,
            resp.status
        )

.. automodule:: urbanairship.devices.static_lists
    :members: StaticLists
