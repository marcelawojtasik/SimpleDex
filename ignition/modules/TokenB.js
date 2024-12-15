const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const TokenBModule = buildModule("TokenBModule", (deployer)=>{
    const initialOwner = "0xafe62bdBA98ADD6f20fF618053621EDE438CD04F";

    const tokenB = deployer.contract("TokenB", [initialOwner]);
    return {tokenB};
});

module.exports = TokenBModule;

//https://sepolia.etherscan.io/address/0xF01b65D2f8433Aa6Dc200e75c725DA79d0BdA560#code