Static Lists
============

With the Static List endpoint, you can easily target and manage
lists of devices that are defined in your systems outside of Airship.
Any list or grouping of devices for which the canonical source of data about
the members is elsewhere is a good candidate for Static Lists, e.g., members
of a customer loyalty program.
For more information, see: `the API documentation on Static Lists
<http://docs.airship.com/api/ua.html#static-lists>`__


Create List
-----------

Creates a static list. The body of the request will contain several of the list
object parameters, but the actual list content will be provided by a second call
to the upload endpoint.

The create method has two optional parameters including 'description,' which is a
user-provided description of the list, and 'extras,' which is a dictionary of
string keys to arbitrary JSON values.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_list = UA::StaticList.new(client: airship)
    static_list.name = 'list_name'
    static_list.create(description: 'description', extra: {'key': 'value'})


Upload List
-----------

Lists target identifiers are specified or replaced with an upload to this endpoint.
Uploads must be newline delimited identifiers (text/CSV) as described in RFC 4180,
with commas as the delimiter. The ``StaticList.upload csvfile`` parameter takes an
open file descriptor. A second optional ``gzip`` parameter specifies whether the csvfile
to be uploaded is gzipped. This parameter defaults to false.

The CSV format consists of two columns: 'identifier_type' and 'identifier'.
'identifier_type' must be one of 'alias', 'named_user', 'ios_channel', 'android_channel',
or 'amazon_channel'. 'identifier' is the associated identifier you wish to send to.

The maximum number of 'identifier_type,identifier' pairs that may be uploaded to a list
is 10 million.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_list = UA::StaticList.new(client: airship)
    static_list.name = 'list_name'
    File.open('csv_file', 'rb') do |csv|
        static_list.upload(csv_file: csv, gzip: false)
    end


Update List
-----------

Updates the metadata of a static list.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_list = UA::StaticList.new(client: airship)
    static_list.name = 'list_name'
    static_list.update(description: 'new description', 'extra': {'new_key': 'new_value' })


Delete List
-----------

Delete a static list.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_list = UA::StaticList.new(client: airship)
    static_list.name = 'list_name'
    static_list.delete

.. note::

    If you are attempting to update a current list by deleting it
    and then recreating it with new data, stop and go to the upload
    endpoint. There is no need to delete a list before uploading a
    new CSV file. 


Lookup List
-----------
Retrieve information about one static list.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_list = UA::StaticList.new(client: airship)
    static_list.name = 'list_name'
    static_list.lookup

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

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    static_lists = UA::StaticLists.new(client: airship)

    static_lists.each do |static_list|
        puts(static_list)
    end
