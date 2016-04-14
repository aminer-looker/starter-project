#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo'

############################################################################################################

m.controller 'TodoController', (
  $scope
  DatafluxEvent
  TodoModelActions
  TodoModelStore
)->

  $scope.todo = TodoModelStore.get($scope.modelId)?.toHash() or {}

  # Listener Methods ###############################################################################

  TodoModelStore.$listen (event, id)->
    todo = TodoModelStore.get($scope.modelId)
    return unless todo?

    todo.mergeInto $scope.todo

  # Scope Functions ################################################################################

  $scope.doneChanged = ->
    todo = TodoModelStore.get($scope.modelId)
    return unless todo?

    todo.isDone = ! todo.isDone
    TodoModelActions.update(todo)

  $scope.textChanged = ->
    todo = TodoModelStore.get($scope.modelId)
    return unless todo?

    todo.text = $scope.todo.text
    TodoModelActions.update(todo)
