require("@nomicfoundation/hardhat-toolbox");
require('@nomicfoundation/hardhat-ethers');
require('dotenv').config();

const { AMOY_API_URL,PRIVATE_KEY} = process.env ;

module.exports = {
  defaulNetwork: "amoy",
  networks: {
    hardhat: {
    },
    amoy: {
      url: AMOY_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
  solidity: {
    version: "0.8.27",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}