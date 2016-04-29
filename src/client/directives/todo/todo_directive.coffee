#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo'

############################################################################################################

# The "todo" directive is responsible for a single line in the todo list.  It is included in an `ng-repeat`
# directive by the `todo_list` directive, and each one is given a `modelId` attribute with the id of the
# particular todo item controlled by that directive.
#
# In Dataflux, directives generally are quite small, and follow specific conventions:
#
#   * they always specify a controller
#   * they are almost always restricted to "elements"
#   * they *always* use isolate scope, and *never* pass in full-fledged objects (usually just IDs)
#   * they only use `link` functions when absolutely necessary, and these are only permitted to do the kind
#     of things a template is permitted to do
#
# This last bit about `link` functions deserves some further explanation.  It generally means that you
# shouldn't maintain state, fire actions, manipulate controllers, or otherwise do things which you wouldn't
# be able to do in a template. Things you *are* allowed to do generally come down to:
#
#   * set a watch on a scope variable and mutate the DOM
#   * listen to DOM events and call functions placed on the scope by a controller
m.directive 'todo', ->
  controller: 'TodoController'
  restrict: 'E'
  scope:
    modelId: '@'
  template: templates['directives/todo']
