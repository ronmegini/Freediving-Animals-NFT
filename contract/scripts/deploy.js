const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const CONTRACT_NAME = process.env.CONTRACT_NAME;
  const CONTRACT_SYMBOL = process.env.CONTRACT_SYMBOL;
  const CONTRACT_BASE_INIT = process.env.CONTRACT_BASE_INIT;
  const NFT = await hre.ethers.getContractFactory("FDA");
  const nft = await NFT.deploy(CONTRACT_NAME, CONTRACT_SYMBOL, CONTRACT_BASE_INIT);
  await nft.deployed();
  let msg = CONTRACT_NAME + ' (' + CONTRACT_SYMBOL+ ') deployed to: ';
  console.log(msg, nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });