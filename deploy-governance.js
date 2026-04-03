const hre = require("hardhat");

async function main() {
  const GOV_TOKEN = "0x..."; // Your DAO Token
  
  const Governor = await hre.ethers.getContractFactory("GovernorAlpha");
  const gov = await Governor.deploy(GOV_TOKEN);

  await gov.waitForDeployment();
  console.log("Governance Engine deployed to:", await gov.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
