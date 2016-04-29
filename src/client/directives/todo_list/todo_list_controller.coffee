#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo_list'

############################################################################################################

# TodoListController is responsible for the whole todo list.  As a controller which appears only once on the
# page, it simple goes directly to the TodoModelStore and fetches the entire list of todo items.  Since the
# store starts out empty, the controller prompts it to load any todo items in local storage by firing the
# `TodoModelActions.loadAll` action.
#
# It then sets up a listener on the store so that it is informed once the list of items has been loaded, and
# again any time the list changes later on.  This allows it to replace the todo list on the scope, thus
# prompting the `ng-repeat` directive to add any missing directives for new items (or to remove excess
# directives for those which have been removed).

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
