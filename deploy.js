const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const { interface, bytecode } = require('./compile');

const provider = new HDWalletProvider(
	'short palm until garden intact glad affair bracket brass deputy add rib',
	'https://rinkeby.infura.io/v3/7e71537ccd064dd1b47c67b2069145a2'
);

const web3 = new Web3(provider);

// this function is created just to be able to use async
// because async caanot be used outside a function
const deploy = async () => {
	const accounts = await web3.eth.getAccounts();
	console.log('Attemping to deploy from account', accounts[0]);
	const result = await new web3.eth.Contract(JSON.parse(interface))
		.deploy({ data: bytecode})
		.send({ gas: '1000000', from: accounts[0] });

	console.log('Contract deployed to ', result.options.address);
};
deploy();