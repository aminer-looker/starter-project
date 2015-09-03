require 'when/monitor/console'

chai = require 'chai'
chai.use require 'sinon-chai'

chai.config.includeStack = true

global._      = require '../src/underscore'
global.assert = chai.assert
global.expect = chai.expect
global.should = chai.should()
global.util   = require 'util'
global.w      = require 'when'
