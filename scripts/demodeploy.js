const hre = require("hardhat");
async function main() {
// Almost all of the functions we mark async await because in blockchain,
// we have to wait for the contract to deploy, the transaction to be processed, etc.
//console.log(await hre.ethers.getSigners()) 
const [signer] = await hre.ethers.getSigners()
console.log(await signer.getBalance())

}
// Recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});