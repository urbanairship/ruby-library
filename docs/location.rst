Locations
=========

This class allows you to search for location information in
various ways.


Name Lookup
-----------

Search for a location boundary by name. The search primarily
uses the location names, but you can also filter the results
by boundary type. See `the API documentation on location
<http://docs.urbanairship.com/api/ua.html#location>`_
for more information.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    location = UA::Location.new(client: airship)
    location.name_lookup(name: 'name', type: 'type')

.. note::

    ``name`` is a required parameter, but ``type`` is optional


Coordinates Lookup
------------------

Search for a location by latitude and longitude coordinates. Type is
an optional parameter. See `the API documentation on coordinates lookup
<http://docs.urbanairship.com/api/ua.html#lat-long-lookup>`_
for more information.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    location = UA::Location.new(client: airship)
    location.coordinates_lookup(latitude: 123.45, longitude: 123.45, type: 'type')

.. note::

    ``longitude`` and ``latitude`` are required parameters that must be numbers.
    ``Type`` is an optional parameter.


Bounding Box Lookup
-------------------

Search for location using a bounding box. See `the documentation on
bounding box lookup
<http://docs.urbanairship.com/api/ua.html#bounding-box-lookup>`_
for more information.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    location = UA::Location.new(client: airship)
    location.bounding_box_lookup(lat1: 123.45, long1: 123.45,
      lat2: 321.45, long2: 321.45, type: 'type')

.. note::

    ``lat1``, ``long1``, ``lat2``, and ``long2`` and are required parameters that must be numbers.
    ``Type`` is an optional parameter.


Alias Lookup
------------

Search for location by alias. See `the documentation on alias lookup
<http://docs.urbanairship.com/api/ua.html#alias-lookup>`_

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    location = UA::Location.new(client: airship)
    location.alias_lookup(from_alias: 'us_state=CA')

.. note::

    ``from_alias`` can either be a single alias or an array of aliases.


Polygon Lookup
--------------

Search for location by polygon id. See `the documentation on polygon
lookup <http://docs.urbanairship.com/api/ua.html#polygon-lookup>`_
for more information.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    location = UA::Location.new(client: airship)
    location.polygon_lookup(polygon_id: 'id', zoom: 1)

.. note::

    ``polygon_id`` needs to be a string. ``Zoom`` is a number ranging from 1-20.


Location Date Ranges
--------------------

Get the possible date ranges that can be used with location endpoints. See `the documentation
on location date ranges <http://docs.urbanairship.com/api/ua.html#location-date-ranges>`__
for more information.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    l = UA::Location.new(client: airship)
    l.date_ranges
