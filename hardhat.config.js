require ("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

//Traigo valores de .env
const alchemyUrl = process.env.ALCHEMY_URL;
const pKey = process.env.PRIVATE_KEY;
const etherscanApiK = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  //Agrego red
  networks:{
    sepolia: {
      url: alchemyUrl,
      accounts: [pKey],
    },
  },
  //configuro apikey
  etherscan: {
    apiKey: {
      sepolia: etherscanApiK,
    },
  },
  //sugerencia npx hardhat verify 
  sourcify: {
    enabled: true
  }
};
