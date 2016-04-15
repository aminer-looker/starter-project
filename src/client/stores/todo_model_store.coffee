#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'stores', []

############################################################################################################

m.factory 'TodoModelActions', (Reflux)->
  return Reflux.createActions ['loadAll', 'create', 'update', 'delete']

############################################################################################################

m.factory 'TodoModelStore', (
  DatafluxEvent
  TodoModel
  Reflux
  TodoModelActions
)->

  Reflux.createStore

    init: ->
      @listen (event, id)=>
        return unless event is DatafluxEvent.change

        if not @hasEmptyTodo()
          @onCreate()

    listenables: TodoModelActions

    # Public Method s###############################################################################

    getAll: ->
      return (model.toProxy() for model in TodoModel.getAll())

    get: (id)->
      return TodoModel.get(id)?.toProxy() or null

    hasEmptyTodo: ->
      for todo in TodoModel.getAll()
        return true if todo.isEmpty

      return false

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
      TodoModel.destroy id
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
