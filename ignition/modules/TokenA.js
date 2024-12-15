const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const TokenAModule = buildModule("TokenAModule", (deployer)=>{
    const initialOwner = "0xafe62bdBA98ADD6f20fF618053621EDE438CD04F";

    const tokenA = deployer.contract("TokenA", [initialOwner]);
    return {tokenA};
});

module.exports = TokenAModule;


//https://sepolia.etherscan.io/address/0xae38Ce2Ad024557916BCa0C1f7C9e0da772A2765#code