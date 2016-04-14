#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'directives.todo'

############################################################################################################

m.directive 'todo', (
)->
  controller: 'TodoController'
  restrict: 'E'
  scope:
    modelId: '@'
  template: templates['directives/todo']
