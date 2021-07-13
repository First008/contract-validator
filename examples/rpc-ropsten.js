
// This example shows how to connect ropsten test network

var Web3 = require('web3');
var web3;


(async () => {

    web3 = await new Web3(Web3.givenProvider || 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161');

    var isConnected = await web3.eth.net.isListening();
    console.log(isConnected);

})();