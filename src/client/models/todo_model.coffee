#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'models'

############################################################################################################

m.factory 'TodoModel', (
  DS
  ModelProxy
)->

  TodoModel = DS.defineResource

    name: 'todo'

    fields: [
      'id'
      'isDone'
      'text'
    ]

    computed:

      isEmpty: ['isDone', 'text', (isDone, text)->
        return !isDone and text.length is 0
      ]

    methods:

      toProxy: ->
        return new ModelProxy this, fields:TodoModel.fields

m.run (TodoModel)-> # force model to load
