const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const SimpleDexModule = buildModule("SimpleDexModule", (deployer) => {
    // Address localhost deploy
    /*const tokenAAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    const tokenBAddress  = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";*/
    const tokenAAddress = "0xae38Ce2Ad024557916BCa0C1f7C9e0da772A2765";
    const tokenBAddress = "0xF01b65D2f8433Aa6Dc200e75c725DA79d0BdA560";

    // Despliega SimpleDex con las direcciones de TokenA y TokenB
    const simpleDex = deployer.contract("SimpleDEX", [tokenAAddress, tokenBAddress]);

    return { simpleDex };
});

module.exports = SimpleDexModule;

//https://sepolia.etherscan.io/address/0xF01b65D2f8433Aa6Dc200e75c725DA79d0BdA560#code