const fs = require('fs')
var solc = require('solc');
var path        = require('path');

function compile(nameOfTheFile) {
  String(nameOfTheFile)
  console.log(nameOfTheFile)
  const testSol = fs.readFileSync('uploads/' + nameOfTheFile, 'utf8')

  // FIXME dosyayi solc ye okut ?
  var input = {
    language: 'Solidity',
    sources: {
      'test.sol':
      {
        content: testSol
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

  // `output` here contains the JSON output as specified in the documentation
  for (var contractName in output.contracts[nameOfTheFile]) {
    console.log(
      contractName +
      ': ' +
      output.contracts[nameOfTheFile][contractName].evm.bytecode.object
    );
  }
  fs.writeFileSync('compiles/test', output.contracts[nameOfTheFile][contractName].evm.bytecode.object);
  return output.contracts[nameOfTheFile][contractName].evm.bytecode.object;

}

module.exports = { compile };
