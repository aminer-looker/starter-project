
m = module.exports = angular.module 'dataflux', ['js-data']

############################################################################################################

# DatafluxEvent is a constant which defines the types of notifications a store can emit.  While,
# technically, any string will do as an event name, it's convenient to keep them all in the same place, so
# this is where we keep them.

m.constant 'DatafluxEvent',
  change: 'change'
  create: 'create'
  delete: 'delete'
  update: 'update'

############################################################################################################

# The following items configure JSData to use local storage for it's permanent data store instead of a REST
# API or database.  Mostly, this is to keep things simple for the sake of this example.  In Helltool, we
# just use the REST adapter which comes installed by default.

m.config (DSLocalStorageAdapterProvider)->
  DSLocalStorageAdapterProvider.defaults.basePath = '/js-data/'

m.run (DS, DSLocalStorageAdapter)->
  DS.registerAdapter 'localstorage', DSLocalStorageAdapter, default: true
  adapter = DS.getAdapter 'localstorage'

  adapter.defaults.serialize = (resourceConfig, payload)->
    _(payload).pick resourceConfig.fields

  adapter.defaults.deserialize = (resourceConfig, payload)->
    _(payload).pick resourceConfig.fields

############################################################################################################

# The following registers `Reflux` with Angular so that it is available through Angular's dependency
# injection. We also customize Reflux with a few conveniences.

m.factory 'Reflux', ($log, $rootScope, DatafluxEvent)->

  reflux.StoreMethods.$listen = (callback)->
    if typeof callback != 'function'
      throw new Error 'callback is not a function'

    @listen (args...)->
      $rootScope.$applyAsync ->
        callback.apply(null, args)

  reflux.logActions = (context, actions)->
    logAction = (context, label, args...) ->
      console.log "Firing: #{context}.#{label}", args...
      return undefined # don't change the args list

    for label, action of actions
      do (context, action, label)->

        action.preEmit = (args...) -> logAction context, label, args...

        for subLabel, subAction of action
          if subAction.preEmit?
            do (subAction, subLabel) ->
              subAction.preEmit = (args...) -> logAction context, "#{label}.#{subLabel}", args...

    return actions

  return reflux
