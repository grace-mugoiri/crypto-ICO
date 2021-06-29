const path = require('path');
const fs = require('fs');
const solc = require('solc');

const ICOpath = path.resolve(__dirname, 'contracts', 'ICO.sol');
const source = fs.readFileSync(ICOpath, 'utf8');

module.exports = solc.compile(source,1).contracts[':ICO'];
console.log(solc.compile(source,1));


