require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" }); // This gets the environment variables

module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: "https://holy-omniscient-meme.matic-testnet.discover.quiknode.pro/844a88e15be1e30d1f855bc750b2401cc57b3089/",
      accounts: ["af979841c98418527e39650ee81645fd7e740c70acc15cd633a42db257375c1d"],
    },
  },
};
