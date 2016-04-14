#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

fs = require 'fs'

EXTERNAL_LIBS = [
    'angular'
    'jade/lib/runtime'
    'jquery'
    'js-data'
    'js-data-angular'
    'js-data-localstorage'
    'reflux-core'
    'underscore'
    'underscore.inflections'
]

############################################################################################################

module.exports = (grunt)->

    grunt.loadTasks tasks for tasks in grunt.file.expand './node_modules/grunt-*/tasks'

    grunt.config.init

        copy:
            assets_build:
                files: [
                    {expand:true, cwd:'./assets/', src:'**/*', dest:'./build/server/static'}
                ]
            common_source:
                files: [
                    {expand:true, cwd:'./src', src:'*.coffee', dest:'./build', ext:'.coffee'}
                ]
            server_source:
                files: [
                    expand: true
                    cwd:    './src/server'
                    src:    '**/*.coffee'
                    dest:   './build/server'
                    ext:    '.coffee'
                ]

        clean:
            assets:       ['./build/server/static/data', './build/server/static/images']
            build:        ['./build']
            dist:         ['./dist']
            templates:    ['./src/client/templates.js']
            imports_scss: ['./src/client/imports.scss']

        jade:
            pages:
                options:
                    pretty: true
                files: [
                    expand: true
                    cwd:  './src/client'
                    src:  '**/index.jade'
                    dest: './build/server/static'
                    ext:  '.html'
                ]
            templates:
                options:
                    client: true
                    node: true
                    processName: (path)->
                        pathElements = path.split '\/'
                        while true
                            element = pathElements.shift()
                            break if element is 'client'
                        pathElements.pop()
                        name = pathElements.join '/'
                        name = name.replace '.jade', ''
                        return name
                files:
                    './src/client/templates.js': ['./src/client/**/!(index)*.jade']

        sass:
            all:
                options:
                  sourcemap: 'none'
                files:
                    './build/server/static/main.css': [ './src/client/imports.scss' ]

        sass_globbing:
            all:
                files:
                    './src/client/imports.scss': [
                        './src/client/styles/main.scss'
                        './src/client/directives/**/*.scss'
                        './src/client/index.scss'
                    ]

        watch:
            assets:
                files: ['./assets/**/*']
                tasks: ['copy:assets_build']
            client_source:
                files: ['./src/client/**/*.coffee', './src/*.coffee']
                tasks: ['browserify:internal']
            server_source:
                files: ['./src/server/**/*.coffee', './src/*.coffee']
                tasks: ['copy:server_source']
            jade_pages:
                files: ['./src/**/index.jade']
                tasks: ['jade:pages']
            jade_templates:
                files: ['./src/**/!(index).jade']
                tasks: ['jade:templates', 'browserify:internal']
            sass:
                files: ['./src/**/*.scss']
                tasks: ['sass_globbing', 'sass']

    # Compound Tasks #######################################################################################

    grunt.registerTask 'build', 'build the project to be run from a local server',
        ['jade', 'build:copy', 'build:css', 'browserify:external', 'browserify:internal']

    grunt.registerTask 'build:copy', 'helper task for build',
        ['copy:assets_build', 'copy:common_source', 'copy:server_source']

    grunt.registerTask 'build:css', 'helper task for build',
        ['sass_globbing', 'sass']

    grunt.registerTask 'default', 'rebuild the project from scratch and start a local HTTP server',
        ['clean', 'start']

    grunt.registerTask 'start', 'build the project and start a local HTTP server',
        ['build', 'script:start']

    grunt.registerTask 'test', 'run unit tests',
        ['mochaTest']

    # Code Tasks ###########################################################################################

    grunt.registerTask 'browserify:external', "Bundle 3rd-party libraries used in the app", ->
        grunt.file.mkdir './build/server/static'
        done = this.async()

        args = [].concat ("--require=#{lib}" for lib in EXTERNAL_LIBS), [
            '--outfile=./build/server/static/external.js'
            '--ignore-missing'
        ]

        options = cmd:'browserify', args:args
        grunt.util.spawn options, (error)->
            console.log error if error?
            done()

    grunt.registerTask 'browserify:internal', "Bundle source files needed in the browser", ->
        grunt.file.mkdir './build/server/static'
        done = this.async()

        libs = []
        for lib in EXTERNAL_LIBS
            parts = lib.split ':'
            libs.push parts[parts.length-1]

        args = [].concat ("--external=#{lib}" for lib in libs), [
            '--extension=.coffee'
            '--ignore-missing'
            '--outfile=./build/server/static/internal.js'
            '--transform=coffeeify'
            './src/client/client.coffee'
        ]

        options = cmd:'browserify', args:args
        grunt.util.spawn options, (error)->
            console.log error if error?
            done()

    # Script Tasks #########################################################################################

    grunt.registerTask 'script:clear', "clear the current terminal buffer", ->
      done = this.async()
      grunt.util.spawn cmd:'clear', opts:{stdio:'inherit'}, (error)-> done(error)

    grunt.registerTask 'script:start', "start a local HTTP server on port 8080", ->
      done = this.async()
      grunt.util.spawn cmd:'./scripts/start', opts:{stdio:'inherit'}, (error)-> done(error)

    # Command-Line Argument Processing #####################################################################

    args = process.argv[..]
    while args.length > 0
        switch args[0]
            when '--grep'
                args.shift()
                grunt.config.merge mochaTest:options:grep:args[0]

        args.shift()
