#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'stores', []

############################################################################################################

# TodoModelActions defines the actions listened to by the TodoModelStore. The TodoListController uses the
# `loadAll` action to do the initial fetching of the saved list, and the TodoController uses the various
# other actions to save changes the user makes as they edit individual items.
m.factory 'TodoModelActions', (Reflux)->
  actions = Reflux.createActions ['loadAll', 'create', 'update', 'delete']
  actions = Reflux.logActions 'TodoModelActions', actions
  return actions

############################################################################################################

# TodoModelStore is the source of all information about Todo items for controllers and other stores.  It
# uses the TodoModel to actually move information into and out of local storage and then triggers
# notifications for the rest of the app (the two Todo*Controllers, in particular) to consume.
m.factory 'TodoModelStore', (
  DatafluxEvent
  TodoModel
  Reflux
  TodoModelActions
)->

  Reflux.createStore

    # Performs any initialization needed for this store.  For stores which keep information in instance
    # variables, this is the place to set them up to represent an "empty" state.  For stores which listen to
    # other stores, this is the place to register those listners and define their actions.
    #
    # It so happens that this store listens to itself.  If ever it detects that it doesn't have an "empty"
    # todo item waiting for the user to fill in, it will create a new one.  Since the UI doesn't have an
    # explicit "new" button, this is how new items are added to the list.
    #
    # Note that the listener calls the `@onCreate` method instead of the `TodoModelActions.create()`
    # function.  Within a store, you should never invoke another action.  Instead, there are two choices.
    # First, if the action you want to trigger belongs to the same store, simply invoke its handler
    # directly (as is done here).  Second, for other cases, trigger a notification from this store, and make
    # the other store listen to it.
    init: ->
      @listen (event, id)=>
        return unless event is DatafluxEvent.change

        if not @hasEmptyTodo()
          @onCreate()

    # Register all the actions this store can listen to.  You can pass in an array containing multiple
    # action objects here, or omit this element completely if this store has no actions.  For each action,
    # Reflux will search for a matching handler method on the store (i.e., "action" -> "onAction").  If such
    # a method exists, it will registered to listen to any invocation of that action.  If not, that action
    # will simply be skipped.
    listenables: TodoModelActions

    # Public Methods ###############################################################################

    # After the opening section containing the `init` and `listenables` declarations, most stores will have
    # a "Public Methods" section.  These should be a collection of read-only methods which grant access to
    # the data contained by the store.  None of these methods should allow any change to the data contained
    # by the store, and should go out of their way to prevent the objects returned from mutating the objects
    # kept inside the store.
    #
    # One of the primary ways we do this is to use the ModelProxy class.  Each *Model object should provide
    # a `toProxy` method which wraps up the model in a ModelProxy.  See the documentation in that class for
    # more details on what it is and how it works.

    getAll: ->
      return (model.toProxy() for model in TodoModel.getAll())

    get: (id)->
      return TodoModel.get(id)?.toProxy() or null

    hasEmptyTodo: ->
      for todo in TodoModel.getAll()
        return true if todo.isEmpty

      return false

    # Action Methods ###############################################################################

    # Next, most stores will have a "Action Methods" section.  For each action this store wants to respond
    # to, a function should be added here named "on<Action>" (e.g., "create" will need an "onCreate" method
    # in this section).  You don't need to add a function for actions your store doesn't care about.
    #
    # For stores which use JSData models to keep their data, these functions usually just manipulate the
    # model objects to load, update, and store the appropriate model or models and then fire notifications
    # about what changed.  Most of the time, we fire a specific notification about exactly what happened and
    # to what object (e.g., `@trigger DatafluxEvent.create, model.id`) followed by a generic notification
    # that some kind of change happened (e.g., `@trigger DatafluxEvent.change`).
    #
    # For stores which keep their data in local variables (there aren't any in this sample project), these
    # functions simply make the appropriate changes to the local variables and fire off notifications just
    # as described above.
    #
    # Just as with the listeners described above, action handlers should *never* fire actions themselves.
    # instead, they should either: 1) trigger a notification, or 2) directly invoke other handlers (but
    # only on the same store).

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
