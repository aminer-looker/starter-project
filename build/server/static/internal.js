(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function (global){
var MODULES;

if (typeof global === 'undefined') {
  window.global = window;
}

global.$ = require('jquery');

global.angular = require('angular');

global.reflux = require('reflux-core');

global._ = require('../underscore');

require('js-data-angular');

MODULES = ['sample'];

angular.module('app', MODULES).config(function($locationProvider) {
  return $locationProvider.html5Mode(true);
});

console.log("client is ready");


}).call(this,typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
},{"../underscore":2,"angular":"angular","jquery":"jquery","js-data-angular":"js-data-angular","reflux-core":"reflux-core"}],2:[function(require,module,exports){
var _, inflections;

_ = require('underscore');

inflections = require('underscore.inflections');

_.mixin(inflections);

module.exports = _;


},{"underscore":"underscore","underscore.inflections":"underscore.inflections"}]},{},[1]);
