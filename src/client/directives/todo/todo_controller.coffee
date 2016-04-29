#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo'

############################################################################################################

# TodoController is responsible for a single line of the todo list.  As a controller which appears many
# times in a page, it expects to receive the identifier of it's model on the scope, and then uses the
# TodoModelStore to fetch the actual data using that identifier.  With the data in hand, it updates the
# scope with all the information necessary to render the template.
#
# It also sets up a listener on the store so that it is informed any time a todo item changes.  If it
# happens to be the one this controller cares about, it will update the scope with the new information.
#
# Finally, the controller adds a bunch of functions to the scope which are to be used as event handlers in
# the template's `ng-click`, `ng-change` and other directives.  These event handlers each fire off actions
# which correspond to the user's requested change.  The TodoStore will be listening for these actions and
# make the matching updates to the underlying data.

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
    return unless id is $scope.modelId
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
