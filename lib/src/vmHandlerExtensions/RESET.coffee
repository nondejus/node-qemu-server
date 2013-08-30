
socketServer = require '../../socketServer'

module.exports = (vm) ->
  console.log "vmHandler Extension received RESET event"

  vm.cfg.status = 'running'
  vm.saveConfig()
  socketServer.toAll 'set-vm-status', vm.name, 'running'
  socketServer.toAll 'msg', {type:'success', msg:"VM #{vm.name} reset."}
