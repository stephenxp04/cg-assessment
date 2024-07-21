const { Web3 } = require('web3');

// Connect to the Polygon RPC node
const web3 = new Web3('https://polygon-rpc.com/');

// Define the block number you want to query
const blockNumber = 26444465;

// Define the Swap event topic hash
const swapEventHash = '0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822';

// Function to get all Swap events in a specific block
async function getSwapEvents() {
    try {
        // Use web3.eth.getPastLogs to get the logs for the specified block and event signature
        const logs = await web3.eth.getPastLogs({
            fromBlock: blockNumber,
            toBlock: blockNumber,
            topics: [swapEventHash]
        });

        console.log('Swap events in block', blockNumber);
        console.log(logs);
    } catch (error) {
        console.error('Error fetching swap events:', error);
    }
}

// Run the function
getSwapEvents();
