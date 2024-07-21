const { Web3 } = require('web3');

// MANA contract address on Polygon
const MANA_CONTRACT_ADDRESS = '0xA1c57f48F0Deb89f569dFbE6E2B7f46D33606fD4';

// Polygon RPC URL
const RPC_URL = 'https://polygon-rpc.com/';

// Full ERC20 ABI
const ERC20_ABI = [
    {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [{"name": "", "type": "string"}],
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [{"name": "", "type": "string"}],
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "decimals",
        "outputs": [{"name": "", "type": "uint8"}],
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [{"name": "", "type": "uint256"}],
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{"name": "_owner", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"name": "balance", "type": "uint256"}],
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{"name": "_to", "type": "address"}, {"name": "_value", "type": "uint256"}],
        "name": "transfer",
        "outputs": [{"name": "success", "type": "bool"}],
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [{"name": "_spender", "type": "address"}, {"name": "_value", "type": "uint256"}],
        "name": "approve",
        "outputs": [{"name": "success", "type": "bool"}],
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [{"name": "_owner", "type": "address"}, {"name": "_spender", "type": "address"}],
        "name": "allowance",
        "outputs": [{"name": "remaining", "type": "uint256"}],
        "type": "function"
    }
];

async function getMANAInfo() {
    const web3 = new Web3(RPC_URL);
    const contract = new web3.eth.Contract(ERC20_ABI, MANA_CONTRACT_ADDRESS);

    try {
        const [name, symbol, decimals, totalSupply] = await Promise.all([
            contract.methods.name().call(),
            contract.methods.symbol().call(),
            contract.methods.decimals().call(),
            contract.methods.totalSupply().call()
        ]);

        const totalSupplyInEther = web3.utils.fromWei(totalSupply, 'ether');

        console.log(`Token Name: ${name}`);
        console.log(`Token Symbol: ${symbol}`);
        console.log(`Decimals: ${decimals}`);
        console.log(`Total Supply: ${totalSupplyInEther} ${symbol}`);
    } catch (error) {
        console.error('Error fetching MANA info:', error);
    }
}

getMANAInfo();