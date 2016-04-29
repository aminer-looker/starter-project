#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

m = angular.module 'models'

############################################################################################################

# ModelProxy wraps another object and prevents any changes from being made to the original.  It can be
# configured to only expose certain methods and properties of the original object, and even knows how to
# deal with references to other objects which may, themselves, be proxied.
#
# When a property is first accessed, a deep copy is made so that any changes made anywhere inside it will
# not affect the source object. Any changes made will only affect the copy.
m.factory 'ModelProxy', ->

  class ModelProxy

    # Creates a new ModelProxy. Along with a source object, a set of optional, named arguments should be
    # provided: `fields`, `methods`, and `relations`.  Each of these are arrays of strings which name some
    # property on the source object.
    #
    #  * Fields are treated as opaque data which must be fully protected from mutations, and which should
    #    be cached so that changes to the underlying model aren't reflected in the proxy.
    #  * Methods are treated as functions which are simply copied onto the proxy so that they may be called
    #    at any time.
    #  * Relations are treated as properties which should always be returned as-is from the underlying
    #    source, and which should not permit assignment.
    #
    # Between these three optional arguments, at least one actual property must be named from the source
    # object.
    constructor: (source, options={})->
      if not source then throw new Error 'source is required'
      options.fields ?= []
      options.methods ?= []
      options.relations ?= []

      @_cache = {}
      @_fields = options.fields[..]
      @_methods = options.methods[..]
      @_relations = options.relations[..]
      @_source = source

      if @_fields.length + @_methods.length + @_relations.length is 0
        throw new Error 'no fields, methods, or relations given to proxy'

      definitions = {}
      for field in @_fields
        definitions[field] =
          enumerable: true
          get: @_makeFieldGetter(field)
          set: @_makeFieldSetter(field)

      for method in @_methods
        definitions[method] = value: @_source[method]

      for relation in @_relations
        definitions[relation] =
          enumerable: true
          get: @_makeRelationGetter(relation)
          set: @_makeRelationSetter(relation)

      Object.defineProperties(this, definitions)

    # Class Methods ######################################################################

    @deepClone: (source, options={})->
      return ModelProxy.merge({}, source, options)

    # Performs a deep copy from source onto target while attempting to change as little as possible. This
    # is very helpful in cases where preserving the actual instance of an object or array on the target is
    # desirable (e.g., within an Angular $scope).  This can be used to make a deep clone of an object by
    # providing an empty object as the `target`.
    #
    # This function does have special handling for different kinds of objects:
    #
    #     * arrays are recursively merged element by element, extra elements are removed
    #     * ModelProxy objects have their fields copied over, but nothing else
    #     * regular objects have only their public fields copied (i.e., no functions and nothing starting
    #       with `_` are copied)
    #
    # The return value will be the given `target` provided it was a type which is compatible with the given
    # source object (e.g., an array matches an array, but not a string).
    @merge: (target, source, options={})->
      result = null

      options.conversions ?= []
      for conversion in options.conversions
        return conversion.result if conversion.source is source
      conversion = source: source, result: 'CYCLE'
      options.conversions.push(conversion)

      options.copyFunctions ?= false

      if _.isArray(source)
        result = conversion.result = if _.isArray(target) then target else []
        for element, index in source
          result[index] = ModelProxy.merge(result[index], element, options)

        result.length = source.length

      else if _.isFunction(source)
        return unless options.copyFunctions
        result = conversion.result = source

      else if source?.constructor is ModelProxy
        conversion.source = source._source
        result = conversion.result = if _.isObject(target) then target else {}
        for field, value of result
          delete result[field] unless source.hasOwnProperty(field)

        for field in source._fields
          result[field] = ModelProxy.merge(result[field], source[field], options)

        for relation in source._relations
          result[relation] = ModelProxy.merge(result[relation], source._source[relation], options)

        if options.copyFunctions
          for method in source._methods
            result[method] = source._source[method]

      else if _.isObject(source)
        result = conversion.result = if _.isObject(target) then target else {}
        for field, value of result
          delete result[field] unless source.hasOwnProperty(field)

        for own field, value of source
          continue if field.indexOf('_') is 0
          continue if _.isFunction(value) and not options.copyFunctions
          result[field] = ModelProxy.merge(result[field], value, options)

      else if _.isEqual(source, target)
        result = conversion.result = target

      else
        result = conversion.result = source

      return result

    # Public Methods #####################################################################

    # Returns whether any fields in this ModelProxy differ from the fields on the source object
    checkDirty: ->
      for field in @_fields
        continue unless @_cache.hasOwnProperty(field)
        return true unless _.isEqual(@_cache[field], @_source[field])

      return false

    mergeInto: (target={}, options={})->
      return ModelProxy.merge(target, this, options)

    # Converts the current values of this model project into a simple JavaScript object with not methods or
    # other behavior. Pass in `snakeCaseKeys: true` to convert the names to snake case in the returned
    # hash.
    toHash: ({snakeCaseKeys}={})->
      hash = ModelProxy.deepClone(this)
      if snakeCaseKeys
        newHash = {}
        for key, value of hash
          newHash[_.underscore(key)] = value
        hash = newHash
      hash

    # Private Methods ####################################################################

    _makeFieldGetter: (field)->
      return ->
        value = @_cache[field]
        if value is undefined
          value = @_cache[field] = ModelProxy.deepClone(@_source[field])
        return value

    _makeFieldSetter: (field)->
      return (newValue)->
        @_cache[field] = newValue

    _makeRelationGetter: (relation)->
      convert = (relatedObject)->
        if not _.isFunction(relatedObject.toProxy)
          throw new Error "#{@_source.constructor.name}.#{relation} cannot create a proxy"
        return relatedObject.toProxy()

      return ->
        value = @_cache[relation]
        if value is undefined
          relatedObject = @_source[relation]
          if relatedObject?
            if _.isArray(relatedObject)
              value = @_cache[relation] = (convert(e) for e in relatedObject)
            else
              value = @_cache[relation] = convert(relatedObject)
          else
            value = @_cache[relation] = null

        return value

    _makeRelationSetter: (relation)->
      return -> throw new Error "#{relation} cannot be changed by direct assignment"
