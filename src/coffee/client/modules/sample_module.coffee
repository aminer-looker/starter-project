#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../templates'

############################################################################################################

sample = angular.module 'sample', []

sample.controller 'SampleController', class SampleController

    constructor: ($scope)->
        $scope.name = 'World'

sample.directive 'sampleGreeting', ->
    return {
        restrict: 'C'
        controller: 'SampleController'
        scope: {}
        template: templates['sample-greeting']
    }

# add more things to your module here...
