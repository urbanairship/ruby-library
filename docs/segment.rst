########
Segments
########


***************
Segment Listing
***************

Segment lists are fetched by instantiating an iterator object using ``SegmentList``. For more
information, see `the API documentation <http://docs.urbanairship.com/api/ua.html#segments-information>`__

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'application_key', secret: 'master_secret')
   segment_list = UA::SegmentList.new(airship)

   segment_list.each do |segment|
      puts segment


******************
Creating a Segment
******************

Create a segment for the application. See the segment creation `API documentation
<http://docs.urbanairship.com/api/ua.html#segment-creation>`__ for more information.

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'application_key', secret: 'master_secret')
   segment = UA::Segment.new
   segment.display_name = 'Display Name'
   segment.criteria = { 'tag' => 'existing_tag' }
   segment.create(airship)

.. note::

   Segment attributes are automatically set upon calling ``segment.create(airship)``. They can
   be accessed in the usual manner: ``segment.id``, ``segment.criteria``, etc.


*******************
Modifying a Segment
*******************

Change the display name and/or criteria of a segment. For more information, see the segment
update `API documentation <http://docs.urbanairship.com/api/ua.html#update-segment>`__.

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'application_key', secret: 'master_secret')
   segment = UA::Segment.new
   segment.from_id(airship, 'segment_id')
   segment.display_name = 'Updated Display Name'
   segment.criteria = { 'tag' => 'updated_tag' }
   segment.update(airship)


******************
Deleting a Segment
******************

Delete a segment. For more information, see the segment deletion `API documentation
<http://docs.urbanairship.com/api/ua.html#delete-segment>`__.

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'application_key', secret: 'master_secret')
   segment = UA::Segment.new
   segment.from_id(airship, 'segment_id')
   segment.delete(airship)


**************
Segment Lookup
**************

Fetch a particular segment's display name and criteria. See the individual segment lookup
`API documentation <http://docs.urbanairship.com/api/ua.html#individual-segment-lookup>`__ for
more information.

.. sourcecode:: ruby

   require 'urbanairship'
   UA = Urbanairship
   airship = UA::Client.new(key: 'application_key', secret: 'master_secret')
   segment = UA::Segment.new
   segment.from_id(airship, 'segment_id')
