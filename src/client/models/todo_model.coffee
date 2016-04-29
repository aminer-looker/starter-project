#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'models'

############################################################################################################

# TodoModel is a JSData resource which defines a single todo list item.  In Helltool, models form the basis
# for how we move data back and forth between client and server.  For a great introduction to JSData, watch
# the video at: http://www.js-data.io/docs/home, but the TL;DR version is that JDData is a caching layer for
# JavaScript applications with adapters for getting data from all sorts of different sources, including REST
# APIs (as used in Helltool), Local Storage (as used in this sample project), and many others. The basic
# unit in JSData is a Resource, and what you see below is a resource declaration for a Todo object.
#
# Models are only accessible to stores.  When a store exposes a model (e.g., to a controller), it will call
# the model's `toProxy` method to get a ModelProxy object first, and only expose the ModelProxy instance.

m.factory 'TodoModel', (
  DS
  ModelProxy
)->

  TodoModel = DS.defineResource

    # Defines the name which identifies this resource in JSData.  It can be whatever you like, but it must
    # be unique among all the resources loaded in the same JSData instance.
    name: 'todo'

    # The `fields` declaration is completely outside of JSData, but we use it in a number of places to know
    # how to serialize data belonging to this object (e.g., in the `toProxy` method below).
    fields: [
      'id'
      'isDone'
      'text'
    ]

    # JSData supports "computed" fields.  These values are computed each time any of the upstream fields
    # change, and then the value is cached so that this function is only called when things change.  We
    # try to keep all logic having to do with the model object either in a computed field or in a method
    # belonging to the model, and specifically *out* of the stores and controllers.
    computed:

      isEmpty: ['isDone', 'text', (isDone, text)->
        return !isDone and text.length is 0
      ]

    # JSData allows you to define a set of functions here which will be copied onto each instance of this
    # resource you create.  These become instance methods for those objects.  For any logic having to do
    # with this model which cannot be a computed field (e.g., because it needs parameters), it should be
    # added as a method.
    #
    # All model objects should have at least a `toProxy` method which returns a ModelProxy object which
    # wraps the model. Any computed fields given to the proxy will be "frozen" to the values they had when
    # the proxy was created.  You can also use the "methods" argument to pass in any methods defined on the
    # model object.  These will act on the ModelProxy's data instead of the model's.
    methods:

      toProxy: ->
        return new ModelProxy this, fields:TodoModel.fields

m.run (TodoModel)-> # force model to load
