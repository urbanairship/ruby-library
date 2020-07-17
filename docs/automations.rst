Automations
===========

The Automation class harnesses the Pipeline class in order to provide functionality
for creating, listing, validating, updating, and deleting pipelines. There are a lot 
of moving parts that go into creating a pipeline, so please view our docs on that 
topic here: https://docs.airship.com/api/ua/#schemas%2fpipelineobject

List Existing Automations
-------------------------

This is for viewing existing pipeleines for a project. There are optional parameters
that can be passed into the URI to have control over what pipelines are returned. In the
following example a limit query of 5 will be added to the URI. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.limit = 5
    automation.list_automations

.. note::

  Should return a 200 HTTP status code, and 5 of the most recent Automations

Create Automation 
-----------------

This will use the Pipeline model to create an automation. You may add several
pipelines objects to create several automations/pipelines at once. The example 
below adds two. 

.. code-block:: ruby

List Deleted Automations
------------------------

This is for viewing deleted pipeleines for a project. The optional param here is for "start";
a timestamp of the starting element for paginating results in the format of YYYY-MM-DD. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.start = 2020-02-20
    automation.list_deleted_automations

.. note::

  Should return a 200 HTTP status code, and the deleted automations from either most current
  or from a given start date.

Individual Pipeline Lookup
--------------------------

This is for looking up a single automation with a given id. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.pipeline_id = '86ad9239-373d-d0a5-d5d8-04fed18f79bc'
    automation.lookup_automation

.. note::

  Should return a 200 HTTP status code, and the payload for the automation in question. 

Delete Pipeline
---------------

This is for deleting a pipeline with a given id. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.pipeline_id = '86ad9239-373d-d0a5-d5d8-04fed18f79bc'
    automation.delete_automation

.. note::

    Response should be a 204 No Content