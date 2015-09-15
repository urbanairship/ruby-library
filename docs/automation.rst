Automation
==========

Automated messages allow you to specify the conditions under which
a notification (or notifications) will be delivered. They are created
by assembling ``pipelines`` hash objects.


.. _pipeline:

Pipelines
---------

In the Ruby API library, pipelines are hash objects that consist of:

    * name (string)

    * enabled (boolean) (required)

    * outcome (outcome_) (required)

    * immediate_trigger (immediate_trigger_)

    * historical_trigger (historical_trigger_)

    * constraint (constraint_)

    * condition (condition_set_)

.. note::
    Either immediate_trigger or historical_trigger must be specified when
    creating a pipeline

.. _outcome:

Outcome
-------

``outcome`` is a hash object consisting of a push (required) and delay, which is the
number of seconds to delay before processing the outcome. It is used in creating a pipeline_.
The audience of the push must be set to ``triggered``.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = 'triggered'
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.all
    outcome = UA.outcome(push: p, delay: 10)


.. _immediate_trigger:

Immediate Trigger
-----------------

``immediate_trigger`` defines a condition that activates a trigger immediately when an
event matching it occurs. A single immediate trigger or an array of immediate triggers
can be used when creating a pipeline. There are three types of events that can be used
to create an immediate trigger: ``first_open``, ``tag_added``, or ``tag_removed``.
When specifying an event type of ``tag_added`` or ``tag_removed``, a parameter of
``tag`` will also need to be specified consisting of a string identifying the tag.
An optional parameter ``group`` can also be provided that specifies the tag group for
the tag. When it is not provided, the tag group defaults to 'device'.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    imm_trigger = UA.immediate_trigger(
        type: 'tag_added',
        tag: 'tag_name',
        tag_group: 'tag_group'
    )


.. _historical_trigger:

Historical Trigger
------------------

``historical_trigger`` defines a condition that matches against event data over time.
It consists of the parameters ``type``, ``equals``, and ``days``. This command is currently
limited to the type set to ``open`` and equals set to ``false``, which checks whether the
app has not been opened for the specified time period. The first two parameters are set by
default value, so only the ``days`` parameter needs to be specified.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    hist_trigger = UA.historical_trigger(days: 90)


.. _constraint:

Constraint
----------

There is currently only one type of constraint available: ``rate_constraint``. Rate constraint
describes the limit on the number of pushes that can be sent to an individual device per
specified time period. It consists of:

    * pushes: An integer specifying the maximum number of pushes that can be sent to the device
      per time period.

    * days: An integer specifying the time period in number of days

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    constraint = UA.rate_constraint(pushes: 10, days: 1)


.. _condition_set:

Condition Sets
--------------

Tag conditions evaluate for the presence (or absence) of the specified tag. They are created
by specifying the tag name. You can check for the absence of the tag by setting the ``negated``
parameter to true.

Conditions are combined into a condition set using ``UA.or`` or ``UA.and`` and are
made up of 1-20 conditions. `Or conditions` and `and conditions` cannot be combined.

.. code-block:: ruby

    require 'urbanairship'
    UA = Urbanairship
    condition = UA.tag_condition(tag: 'tag_name', negated: false)
    condition_set = UA.or(condition)


Create an Automated Message
-----------------------------

An automated message is created with a pipeline or an array of pipelines.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = 'triggered'
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.all
    outcome = UA.outcome(push: p, delay: 10)
    imm_trigger = UA.immediate_trigger(
        type: 'tag_added',
        tag: 'test_auto',
        group: 'test-group'
    )
    constraint = UA.constraint(pushes: 10, days: 1)
    condition = UA.tag_condition(tag: 'tag_name')
    or_condition = UA.or(condition)
    pipeline = UA.pipeline(
        name: 'this_pipeline',
        enabled: true,
        outcome: outcome,
        constraint: constraint,
        condition: or_condition,
        immediate_trigger: imm_trigger
    )
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.create(pipelines: pipeline)


Validate Pipeline
-----------------

Pipeline objects are quite complex. To validate the object before creating or updating
it, you can use the validate method.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = 'triggered'
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.all
    outcome = UA.outcome(push: p, delay: 10)
    imm_trigger = UA.immediate_trigger(
        type: 'tag_added',
        tag: 'test_auto',
        group: 'test-group'
    )
    constraint = UA.constraint(pushes: 10, days: 1)
    condition = UA.tag_condition(tag: 'tag_name')
    or_condition = UA.or(condition)
    pipeline = UA.pipeline(
        name: 'this_pipeline',
        enabled: true,
        outcome: outcome,
        constraint: constraint,
        condition: or_condition,
        immediate_trigger: imm_trigger
    )
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.validate(pipelines: pipeline)


List Existing Pipelines
-----------------------

List all existing pipelines. An optional ``limit`` parameter specifies the maximum number of
pipelines to be included in the response. The optional ``enabled`` parameter can be set to
``true`` in order to list only enabled pipelines.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.list_existing(limit: 20, enabled: true)


List Deleted Pipelines
-----------------------

List all deleted pipelines. An optional ``start`` parameter specifies the timestamp of
the starting element. It can be used for paginating results.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.list_deleted(start: '2015-08-01')


Individual Pipeline Lookup
--------------------------

Fetch the current definition of a single pipeline resource.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.lookup(pipeline_id: 'pipeline_id')


Update Pipeline
---------------

Update the state of a single pipeline resource. Partial updates are not permitted.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    p = airship.create_push
    p.audience = 'triggered'
    p.notification = UA.notification(alert: 'Hello')
    p.device_types = UA.all
    outcome = UA.outcome(push: p, delay: 10)
    imm_trigger = UA.immediate_trigger(
        type: 'tag_added',
        tag: 'test_auto',
        group: 'test-group'
    )
    constraint = UA.constraint(pushes: 10, days: 1)
    condition = UA.tag_condition(tag: 'tag_name')
    or_condition = UA.or(condition)
    pipeline = UA.pipeline(
        name: 'this_pipeline',
        enabled: true,
        outcome: outcome,
        constraint: constraint,
        condition: or_condition,
        immediate_trigger: imm_trigger
    )
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.update(pipeline_id: 'pipeline_id', pipeline: pipeline)


Delete Pipeline
---------------

Delete a pipeline resource, which will result in no more pushes being sent. If the
resource is successfully deleted, the response does not include a body.

.. code-block:: ruby

    airship = UA::Client.new(key:'application_key', secret:'master_secret')
    auto_message = UA::AutomatedMessage.new(client: airship)
    auto_message.delete(pipeline_id: 'pipeline_id')