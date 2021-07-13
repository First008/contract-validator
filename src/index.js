const fs = require('fs')
var solc = require('solc');
var path = require('path');
var multer = require('multer')
var express = require('express')
var compile = require('./compile');
var compare = require('./compare');

// Required tool for Eth
var Web3 = require('web3');
var web3;



var storage = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, 'uploads/');
    },
    filename: function (req, file, callback) {
        callback(null, "test.sol");
    }
});

var upload = multer({ storage: storage })



const app = express();
const port = 3000

app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));


app.use('/app', express.static(path.join(__dirname, '../assets')))

app.get('/', (req, res) => {
    // res.sendFile(path.join( __dirname + "assets/html/index.html"))
    res.send('Hello World!')
})

app.post('/provider', function (req, res, next) {
    console.log(req.body.provider);

    switch (req.body.provider) {
        case "Ropsten Test Network": break;
        case "Custom RPC": web3 = new Web3(Web3.givenProvider || 'http://localhost:8545'); console.log("Switching to Custom RPC.."); break;
    }


    // var isConnected = web3.eth.net.isListening();
    // console.log(isConnected);
    (async () => {
        var isConnected = await web3.eth.net.isListening(); console.log(isConnected);
        if (String(isConnected) === "true") { res.status(204).send(); }
        else { res.status(400).send(); }

    })()

})

app.post('/address', function (req, res, next) {
    console.log(req.body.contractAddress);
    fs.writeFileSync('address/contractAddr', req.body.contractAddress);
    res.status(204).send();
})

app.post('/compare', function (req, res, next) {
    // TODO - burada artık karşılaştırma işlemini yapacak fonksiyon çağıruılacak
    // contract=0x03B5407fEC9f045285FA775C9d2e84cb9a31E58A

    (async () => {
        var isConnected = await web3.eth.net.isListening(); console.log(isConnected);
        if (String(isConnected) === "true") {



            compare.compare(web3); res.status(204).send();
        }

        else { res.status(400).send(); }

    })()

    // https://ethereum.stackexchange.com/questions/63069/smart-contract-byte-code-using-web3
})

app.post('/file', upload.single('avatar'), function (req, res, next) {
    // req.file is the `avatar` file
    // req.body will hold the text fields, if there were any



    console.log(req.file);
    console.log(req.file.filename);

    (async () => { console.log(req.file.filename); var bytecode = await compileContract(req.file.filename); console.log(bytecode); })()
    res.status(204).send();

})



app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})




async function compileContract(params) {
    console.log(params)
    return await compile.compile(params);
}