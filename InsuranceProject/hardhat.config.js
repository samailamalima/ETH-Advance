// imports
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    // set mumbai testnet for deploying smart contract
    mumbai: {
      url: "https://holy-omniscient-meme.matic-testnet.discover.quiknode.pro/844a88e15be1e30d1f855bc750b2401cc57b3089/",
      accounts: ["af979841c98418527e39650ee81645fd7e740c70acc15cd633a42db257375c1d"],
    }
  },
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};



