A/B Tests
=========

In this client, we format A/B tests with three to nesting components. The first is the Variant,
the difference between one kind of push and another. The Variant is a part of the Experiment
object, with many variants in an array. Lastly. AbTest handles what Experiments along with their Variants 
get sent to the various API endpoints. Basic pushes can be added straight to the Variant object
on the push instance variable, or a Push object can be created, and the payload applied to the
Variant object. 

List Existing A/B Tests
-----------------------

This endpoint will return the existing A/B tests on a project. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    ab_test = UA::AbTest.new(client: airship)
    ab_test.limit = 5
    ab_test.list_ab_test

.. note::

  Should return a 200 HTTP status code as well as a list of existing A/B tests with a
  default offset and a limit of 5. The limit and offset are optional here. 

Create A/B Test
----------------


.. code-block:: ruby

    
.. note::
  
  Should return a 201 HTTP status code. 

List Scheduled A/B Tests
------------------------

This will list all the scheduled A/B Tests for a project. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    ab_test = UA::AbTest.new(client: airship)
    ab_test.list_scheduled_ab_test

.. note::

  Should return a 200 HTTP status code. Here, you can also apply limit and offset by assigning
  values to the instance variables on the AbTest object. 

Delete A/B Test
----------------

This will delete an A/B Test with a given experiment ID. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    ab_test = UA::AbTest.new(client: airship)
    ab_test.experiment_id = '<experiment_id>'
    ab_test.delete_ab_test

.. note::

    Response should be a 200 HTTP Response

Validate A/B Test
------------------

.. code-block:: ruby


.. note::
  
  Should return a 200 HTTP status code. 

Individual A/B Test Lookup
--------------------------

This will lookup a specific A/B Test with a given experiment_id

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    ab_test = UA::AbTest.new(client: airship)
    ab_test.experiment_id = '<experiment_id>'
    ab_test.lookup_ab_test

.. note::

  Should return a 200 HTTP status code
