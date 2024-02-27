import { ethers } from "hardhat";

async function main() {
  const NFTFactory = await ethers.deployContract("NFTFactory");

  await NFTFactory.waitForDeployment();

  console.log(`NFTFactory Contract has been deployed to ${NFTFactory.target}`);

  const SocialPlatform = await ethers.deployContract("SocialPlatform", [
    NFTFactory.target,
  ]);

  await SocialPlatform.waitForDeployment();

  console.log(
    `Social Platform Contract has been deployed to ${SocialPlatform.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// -------------- FACTORY CONTRACT ADDRESS ------------- \\
// 0x87D5502431BBc2757AC2acbEABA1E9Bac4c5d41E

// -------------- SOCIAL PLATFORM CONTRACT ADDRESS -------------- \\
// 0x179932D2eBd09150B133b204122C96b633d4E291