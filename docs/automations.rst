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
below adds two. If you would like to just add one pipeline, forgo the array,
and assign the pipeline payload directly to automation.pipeline_object.  

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<app_secret>')
    pipeline_one = UA::Pipeline.new(client: airship)
    pipeline_one.enabled = true
    pipeline_one.immediate_trigger = {
        "tag_added": {
            "tag": "new_customer",
            "group": "crm"
        }
    }
    pipeline_one.outcome = {
        "push": {
            "audience": "triggered",
            "device_types": "all",
            "notification": {
                "alert": "Hello new customer!"
            }
        }
    }
    pipeline_two = UA::Pipeline.new(client: airship)
    pipeline_two.enabled = true
    pipeline_two.immediate_trigger = {
        "tag_added": {
            "tag": "new_customer",
            "group": "crm"
        }
    }
    pipeline_two.outcome = {
        "push": {
            "audience": "triggered",
            "device_types": "all",
            "notification": {
                "alert": "Here is a different second alert!"
            }
        }
    }
    pipelines = [pipeline_one.payload, pipeline_two.payload]
    automation = UA::Automation.new(client: airship)
    automation.pipeline_object = pipelines 
    automation.create_automation

.. note::
  
  Should return a 201 HTTP status code. 

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

Validate Automation
-------------------

This endpoint is a lot like the create automation endpoint, the basic set up is the same,
only difference here is the method selected. 

.. code-block:: ruby

  require 'urbanairship'
  UA = Urbanairship
  airship = UA::Client.new(key:'<app_key>', secret:'<app_secret>')
  pipeline = UA::Pipeline.new(client: airship)
  pipeline.enabled = true
  pipeline.immediate_trigger = {
      "tag_added": {
          "tag": "new_customer",
          "group": "crm"
      }
  }
  pipeline.outcome = {
      "push": {
          "audience": "triggered",
          "device_types": "all",
          "notification": {
              "alert": "Hello new customer!"
          }
      }
  }
  automation = UA::Automation.new(client: airship)
  automation.pipeline_object = pipeline.payload
  automation.validate_automation 

.. note::
  
  Should return a 200 HTTP status code. 

Individual Automation Lookup
----------------------------

This is for looking up a single automation with a given ID. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.pipeline_id = '86ad9239-373d-d0a5-d5d8-04fed18f79bc'
    automation.lookup_automation

.. note::

  Should return a 200 HTTP status code, and the payload for the automation in question. 

Update Automation
-----------------

This is for updating an existing automation. You must include the full payload from a POST 
response, with the updates that you want to make within the payload. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    pipeline = UA::Pipeline.new(client: airship)
    pipeline.enabled = true
    pipeline.immediate_trigger = {
      "tag_added": {
         "tag": "new_tag_update",
         "group": "Locale"
        }
    }
    pipeline.outcome = {
      "push": {
         "audience": "triggered",
         "device_types": "all",
         "notification": {
             "alert": "Newly created alert message!"
            }
        }
    }
    automation = UA::Automation.new(client: airship)
    automation.pipeline_id = '0f927674-918c-31ef-51ca-e96fdd234da4'
    automation.pipeline_object = pipeline.payload 
    automation.update_automation

.. note::
  
  Should return a 200 HTTP status code.   

Delete Automation
-----------------

This is for deleting a pipeline with a given ID. 

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'<app_key>', secret:'<secret_key>')
    automation = UA::Automation.new(client: airship)
    automation.pipeline_id = '86ad9239-373d-d0a5-d5d8-04fed18f79bc'
    automation.delete_automation

.. note::

    Response should be a 204 No Content