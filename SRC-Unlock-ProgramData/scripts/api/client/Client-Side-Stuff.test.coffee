ping = console.log('POSTED Request: Ping!')
pong = console.log('Recived Request: Pong!')
# the below code is WIP, but will soon test the connection of the remote proxy.

testfunc = ->
  if ping
    console.log pong

    addEventListener.pong = ->
      console.info 'Remote Javascript/Node running on page'
      return

  return

# the below calls the function above

run = ->
  console.log testfunc
  return
