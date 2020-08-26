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

As described above, the creation of an A/B Test consists of creating a few objects, grabbing
pertinent data out of them, and creating an A/B Test that is as complicated or as simple as you
like. In some cases, it might be easier to assign the payload values yourself, but as pushes,
and the tests themselves get more complicated, it is easier to let the objects do the work for you.


.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    variant_one = UA::Variant.new(client: airship)
    variant_one.push = {
        "notification": {
            "alert": "I love cereal"
        }
    }
    variant_two = UA::Variant.new(client: airship)
    variant_two.push = {
        "notification": {
            "alert": "I prefer oatmeal"
        }
    }
    experiment = UA::Experiment.new(client: airship)
    experiment.name = 'Neat experiment'
    experiment.description = 'See how neat we can get'
    experiment.audience = 'all'
    experiment.device_types = 'all'
    experiment.variants << variant_one.payload
    experiment.variants << variant_two.payload 
    ab_test = UA::AbTest.new(client: airship)
    ab_test.experiment_object = experiment.payload 
    ab_test.create_ab_test
    
.. note::
  
  Should return a 201 HTTP status code as well as other information detailing specific
  information (such as push_id) for the newly created A/B Test. 

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

Very similar to the create A/B Test endpoint, this will validate an A/B Test to 
see if it is formatted properly. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    variant_one = UA::Variant.new(client: airship)
    variant_one.push = {
        "notification": {
            "alert": "I love cereal"
        }
    }
    variant_two = UA::Variant.new(client: airship)
    variant_two.push = {
        "notification": {
            "alert": "I prefer oatmeal"
        }
    }
    experiment = UA::Experiment.new(client: airship)
    experiment.name = 'Neat experiment'
    experiment.description = 'See how neat we can get'
    experiment.audience = 'all'
    experiment.device_types = 'all'
    experiment.variants << variant_one.payload
    experiment.variants << variant_two.payload 
    ab_test = UA::AbTest.new(client: airship)
    ab_test.experiment_object = experiment.payload 
    ab_test.validate_ab_test

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
