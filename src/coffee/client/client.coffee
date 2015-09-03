#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

if typeof(global) is 'undefined'
    window.global = window

angular = require 'angular'

############################################################################################################

angular.module 'app', ['composer', 'work']
    .config ($locationProvider)->
        $locationProvider.html5Mode true

console.log "client is ready"
