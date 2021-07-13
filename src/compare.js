const fs = require('fs')

function compare(web3) {

    var address = fs.readFileSync('address/contractAddr', 'utf8');
    var compiledCode = fs.readFileSync('compiles/test', 'utf8');
    var obtainedCode;

    (async () => {
        var isConnected = await web3.eth.net.isListening(); console.log(isConnected);
        if (String(isConnected) === "true") {
            obtainedCode = await web3.eth.getCode(address);
            fs.writeFileSync('compiles/test1', obtainedCode, 'utf8')
        }
        console.log(obtainedCode);
        if (compiledCode === obtainedCode) {
            console.log("oww yeahh");
        }
        else console.log("kankammmm");
    })()

    



}

module.exports = { compare }