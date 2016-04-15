#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo_list'

############################################################################################################

m.controller 'TodoListController', (
  $scope
  DatafluxEvent
  TodoModelActions
  TodoModelStore
)->

  $scope.todos = []
  $scope.canAdd = false
  TodoModelActions.loadAll()

  # Listener Methods ###############################################################################

  TodoModelStore.$listen (event, id)->
    return unless event is DatafluxEvent.change
    $scope.todos = TodoModelStore.getAll()
    $scope.canAdd = ! TodoModelStore.hasEmptyTodo()

  # Scope Methods ##################################################################################

  $scope.add = ->
    return if ! $scope.canAdd
    TodoModelActions.create()
