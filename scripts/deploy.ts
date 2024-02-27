import { ethers } from "hardhat";

async function main() {
  const NFTFactory = await ethers.deployContract("NFTFactory", [
    "MarkNFT",
    "MNFT",
  ]);

  await NFTFactory.waitForDeployment();

  console.log(`NFTFactory Contract has been deployed to ${NFTFactory.target}`);

  const SocialPlatform = await ethers.deployContract("SocialPlatform", [
    NFTFactory.target,
  ]);

  await SocialPlatform.waitForDeployment();

  console.log(
    `NFTFactory Contract has been deployed to ${SocialPlatform.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
