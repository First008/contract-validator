var solc = require('solc');
const fs = require('fs')

const basitSol = fs.readFileSync('./basit.sol', 'utf8')

// FIXME dosyayi solc ye okut ?
var input = {
  language: 'Solidity',
  sources: {
    'basit.sol': 
    {
      content: basitSol
    }
  },
  settings: {
    outputSelection: {
      '*': {
        '*': ['*']
      }
    }
  }
};

var output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log('output:', output.contracts['basit.sol'].Storage);