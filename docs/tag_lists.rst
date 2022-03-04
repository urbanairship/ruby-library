Tag Lists
=========

Bulk add and/or remove tags by uploading a CSV file of Airship users. For more
information about the use of this endpoint, incluiding CSV file formatting requirements
please see `the Airship Tag Lists API documentation 
<https://docs.airship.com/api/ua/#tag-tag-lists>`__


Create List
-----------

Add tags to your contacts by creating a list and uploading CSV file with user identifiers. 
The body of the request contains the name, description, and optional metadata for the 
list. After you define a list, you populate it with a call to the Upload Tag List method.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key: 'app_key', secret: 'master_secret')
    tags = {'tag_group_name': ['tag1', 'tag2']}

    tag_list = UA::TagList.new(client: airship)
    tag_list.name = 'ua_tags_list_name'
    tag_list.create(description: 'description', extra: {'key': 'value'}, add: tags)


Upload List
-----------

Upload a CSV that will set tag values on the specified channels or named users. See `the
Airship API documentation <https://docs.airship.com/api/ua/#operation-api-tag-lists-list_name-csv-put>`__ for CSV formatting requirements. Set 
the optional `gzip` parameter to `true` if your file is gzip compressed.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key: 'app_key', secret: 'master_secret')

    tag_list = UA::TagList.new(client: airship)
    tag_list.name = 'ua_tags_list_name'
    tag_list.upload(csv_file: 'file_content', gzip: true)


Dowload List Errors
-------------------

During processing, after a list is uploaded, errors can occur. Depending on the type 
of list processing, an error file may be created, showing a user exactly what went wrong.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key: 'app_key', secret: 'master_secret')

    tag_list = UA::TagList.new(client: airship)
    error_csv = tag_list.errors


Retrieve All Tag Lists
----------------------

Retrieve information about all tag lists. This call returns a list of metadata that 
will not contain the actual lists of users.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key: 'app_key', secret: 'master_secret')

    tag_list = UA::TagList.new(client: airship)
    list_response = tag_list.list