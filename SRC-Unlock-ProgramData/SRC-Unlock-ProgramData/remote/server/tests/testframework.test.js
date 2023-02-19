var ping = console.log("POSTED Request: Ping!");
var pong = console.log("Recived Request: Pong!");

// the below code is WIP, but will soon test the connection of the remote proxy.
var testfunc = function test() {
  if (ping) {
    console.log(pong);
    addEventListener.pong = function event() {
      console.info("Remote Javascript/Node running on page");
    };
  }
};

// the below calls the function above

function run() {
  console.log(testfunc);
}
