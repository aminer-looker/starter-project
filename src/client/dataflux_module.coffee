
m = module.exports = angular.module 'dataflux', ['js-data']

############################################################################################################

m.constant 'DatafluxEvent',
  change: 'change'
  create: 'create'
  delete: 'delete'
  update: 'update'

############################################################################################################

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

m.factory 'Reflux', ($log, $rootScope, DatafluxEvent)->

  reflux.StoreMethods.$listen = (callback)->
    if typeof callback != 'function'
      throw new Error 'callback is not a function'

    @listen (args...)->
      $rootScope.$applyAsync ->
        callback.apply(null, args)

  reflux.logActions = (context, actions)->
    return actions unless debug.enabled

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
