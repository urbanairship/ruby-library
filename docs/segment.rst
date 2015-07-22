Segments
========

Segment Listing
---------------
Segment lists are fetched by instantiating an iterator object 
using :py:class:`SegmentList`. 
For more information, see:
http://docs.urbanairship.com/api/ua.html#segments-information

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    segment_list = ua.SegmentList(airship) 

    for segment in segment_list:
        print(segment.display_name)

.. automodule:: urbanairship.devices.segment
    :noindex:


Creating a Segment 
------------------
Create a segment for this application. For more information, see:
http://docs.urbanairship.com/api/ua.html#segment-creation

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    segment = ua.Segment()
    segment.display_name = "Display Name"
    segment.criteria = {"tag":"Existing Tag"}
    segment.create(airship)

.. automodule:: urbanairship.devices.segment
    :members: Segment
    :noindex:

.. note::
    A segment's id is automatically set upon calling *segment.create(airship)*
    and can be accessed using *segment.id*

Modifying a Segment
-------------------
Change the display name and criteria for a segment. For more information, see:
http://docs.urbanairship.com/api/ua.html#put--api-segments-(segment_id)

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    segment = ua.Segment()
    segment.from_id(airship, "segment_id")
    segment.display_name = "New Display Name"
    segment.criteria = {'and': [{'tag': 'new_tag'},
                                {'not': {'tag': 'other_tag'}}]}
    segment.update(airship)

.. automodule:: urbanairship.devices.segment
    :members: Segment
    :noindex:


Deleting a Segment
------------------
A segment can be deleted by calling the delete function on the segment.
For more information, see:
http://docs.urbanairship.com/api/ua.html#delete--api-segments-(segment_id)

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    segment = ua.Segment()
    segment.from_id(airship, "segment_id")
    segment.delete(airship)

.. automodule:: urbanairship.devices.segment
    :members: Segment
    :noindex:


Segment Lookup 
--------------
Fetch a particular segment's display name and criteria.
http://docs.urbanairship.com/api/ua.html#get--api-segments-(segment_id)

.. code-block:: python

    import urbanairship as ua
    airship = ua.Airship("app_key", "master_secret")
    segment = ua.Segment()
    segment.from_id(airship, "segment_id")

.. automodule:: urbanairship.devices.segment
    :members: Segment
    :noindex:
