#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

# Configure Global Variables ###############################################################################

# Allow Node.js-style `global` in addition to `window`
if typeof(global) is 'undefined'
    window.global = window

global.$ = require 'jquery' # must preceed Angular

global.angular   = require 'angular'
global.reflux    = require 'reflux-core'
global.templates = require './templates'
global._         = require '../underscore'

global.JSData                = require 'js-data'
global.DSLocalStorageAdapter = require 'js-data-localstorage'
require 'js-data-angular' # must follow `js-data` and `angular`

# Configure Project ########################################################################################

# Add all your modules here.
MODULES = [
    require('./dataflux_module').name
    require('./directives/directives_module').name
    require('./models/models_module').name
    require('./stores/stores_module').name
]

angular.module 'app', MODULES
    .config ($locationProvider)->
        $locationProvider.html5Mode true

console.log "client is ready"
