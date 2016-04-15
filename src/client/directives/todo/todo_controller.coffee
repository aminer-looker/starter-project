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

  # Helper Functions ###############################################################################

  _updateScope = ->
    todo = TodoModelStore.get($scope.modelId) or {}

    $scope.todo     = if todo.toHash? then todo.toHash() else todo
    $scope.noText   = (todo.text?.length or 0) is 0
    $scope.complete = todo.isDone

  _updateScope()

  # Listener Methods ###############################################################################

  TodoModelStore.$listen (event, id)->
    _updateScope()

  # Scope Functions ################################################################################

  $scope.delete = ->
    TodoModelActions.delete $scope.modelId

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
