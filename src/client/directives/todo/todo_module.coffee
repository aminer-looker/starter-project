#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = module.exports = angular.module 'directives.todo', [
  'dataflux'
  'stores'
]

require './todo_controller'
require './todo_directive'
