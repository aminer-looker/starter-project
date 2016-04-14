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

    methods:

      toProxy: ->
        return new ModelProxy this, fields:TodoModel.fields

m.run (TodoModel)-> # force model to load
