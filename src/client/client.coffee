#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

# Configure Global Variables ###############################################################################

# Allow Node.js-style `global` in addition to `window`
if typeof(global) is 'undefined'
    window.global = window

global.$ = require 'jquery' # must preceed Angular

global.angular = require 'angular'
global.reflux  = require 'reflux-core'
global._       = require '../underscore'

require 'js-data-angular' # must follow Angular, registers `DS` with Angular DI

# Configure Project ########################################################################################

# Add all your modules here.
MODULES = [
    'sample'
]

angular.module 'app', MODULES
    .config ($locationProvider)->
        $locationProvider.html5Mode true

console.log "client is ready"
