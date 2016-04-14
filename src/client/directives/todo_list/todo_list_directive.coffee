#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo_list'

############################################################################################################

m.directive 'todoList', (
)->
  restrict: 'E'
  scope: {}
  template: templates['directives/todo_list']
