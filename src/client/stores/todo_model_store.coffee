#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'stores', []

############################################################################################################

m.factory 'TodoModelActions', ->
  actions = Reflux.createActions ['loadAll', 'create', 'update', 'delete']

############################################################################################################

m.factory 'TodoModelStore', (
  DatafluxEvent
  TodoModel
  Reflux
)->

  Reflux.createStore

    # Public Method s###############################################################################

    getAll: ->
      return (model.toProxy() for model in TodoModel.getAll())

    get: (id)->
      model = TodoModel.get id

    # Action Methods ###############################################################################

    onCreate: (params={})->
      params.isDone ?= false
      params.text ?= ""

      TodoModel.create params
        .then (model)=>
          console.log "created ", model
          @trigger DatafluxEvent.create, model.id
          @trigger DatafluxEvent.change
        .catch (error)->
          console.error "Could not create: ", error

    onDelete: (id)->
      TodoModel.delete id
        .then =>
          console.log "deleted Todo #{id}"
          @trigger DatafluxEvent.delete, id
          @trigger DatafluxEvent.change
        .catch (error)->
          console.error "Could not create: ", error

    onLoadAll: ->
      TodoModel.findAll()
        .then (models)=>
          console.log "loaded all Todos"
          @trigger DatafluxEvent.change
        .catch (error)->
          console.error "Could not load all: ", error

    onUpdate: (proxy)->
      return unless proxy.checkDirty()

      params = proxy.toHash()
      delete params.id

      TodoModel.update proxy.id, params
        .then (model)=>
          console.log "updated ", model
          @trigger DatafluxEvent.update, model.id
          @trigger DatafluxEvent.change
        .catch (error)->
          console.error "Could not update: ", error
