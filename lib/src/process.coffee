proc      = require 'child_process'
parser    = require './parser'
vmHandler = require '../vmHandler'

class Process
  constructor: ->
    @process = undefined
    @bin     = 'qemu-system-x86_64'

  start: (vmCfg) ->
    try
      args     = parser.vmCfgToArgs vmCfg
      @process = proc.spawn @bin, args.args, {stdio: 'inherit', detached: true}

      console.log "QEMU start-parameters: #{args.args.join(' ')}"

      @process.on 'exit', (code, signal) ->
        if code is 0 then console.log   "qemu process exit clean."
        else              console.error "qemu process exit with error: #{code}, signal: #{signal}"
        vmHandler.SHUTDOWN vmCfg.name
    catch e
      console.error "process:start:e"
      console.dir    e
      vmHandler.SHUTDOWN vmCfg.name
      vmHandler.stopQMP  vmCfg.name

module.exports.Process = Process
