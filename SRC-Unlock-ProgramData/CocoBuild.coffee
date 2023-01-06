###*
# Module dependencies.
###

###*
# Noop.
###

noop = ->

###*
# Create a new Batch.
###

Batch = ->
  `var Emitter`
  if !(this instanceof Batch)
    return new Batch
  @fns = []
  @concurrency Infinity
  @throws true
  i = 0
  len = arguments.length
  while i < len
    @push arguments[i]
    ++i
  return

try
  EventEmitter = require('events').EventEmitter
  if !EventEmitter
    throw new Error
catch err
  Emitter = require('emitter')

###*
# Defer.
###

defer = if typeof process != 'undefined' and process and typeof process.nextTick == 'function' then process.nextTick else ((fn) ->
  setTimeout fn
  return
)

###*
# Expose `Batch`.
###

module.exports = Batch

###*
# Inherit from `EventEmitter.prototype`.
###

if EventEmitter
  Batch::__proto__ = EventEmitter.prototype
else
  Emitter Batch.prototype

###*
# Set concurrency to `n`.
#
# @param {Number} n
# @return {Batch}
# @api public
###

Batch::concurrency = (n) ->
  @n = n
  this

###*
# Queue a function.
#
# @param {Function} fn
# @return {Batch}
# @api public
###

Batch::push = (fn) ->
  @fns.push fn
  this

###*
# Set wether Batch will or will not throw up.
#
# @param  {Boolean} throws
# @return {Batch}
# @api public
###

Batch::throws = (throws) ->
  @e = ! !throws
  this

###*
# Execute all queued functions in parallel,
# executing `cb(err, results)`.
#
# @param {Function} cb
# @return {Batch}
# @api public
###

Batch::end = (cb) ->
  `var cb`
  self = this
  total = @fns.length
  pending = total
  results = []
  errors = []
  cb = cb or noop
  fns = @fns
  max = @n
  throws = @e
  index = 0
  done = undefined
  # empty
  # process

  next = ->
    i = index++
    fn = fns[i]

    callback = (err, res) ->
      if done
        return
      if err and throws
        return done = true
        defer(->
          cb err
          return
        )

      complete = total - pending + 1
      end = new Date
      results[i] = res
      errors[i] = err
      self.emit 'progress',
        index: i
        value: res
        error: err
        pending: pending
        total: total
        complete: complete
        percent: complete / total * 100 | 0
        start: start
        end: end
        duration: end - start
      if --pending
        next()
      else
        defer ->
          if !throws
            cb errors, results
          else
            cb null, results
          return
      return

    if !fn
      return
    start = new Date
    try
      fn callback
    catch err
      callback err
    return

  if !fns.length
    return defer(->
      cb null, results
      return
    )
  # concurrency
  while i < fns.length
    if i == max
      break
    next()
    i++
  this
