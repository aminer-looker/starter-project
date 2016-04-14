#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = module.exports = angular.module 'directives', [
  'dataflux'
  'stores'

  require('./todo/todo_module').name
  require('./todo_list/todo_list_module').name
]
