// to run: npx hardhat run scripts/deploy.js
const hre = require("hardhat");
// console.log(hre);

async function main() {
    const currentTimestampInSecond = Math.round(Date.now() / 1000);
    const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    const unlockedTime = currentTimestampInSecond + ONE_YEAR_IN_SECONDS;

    const lockedAmount = hre.ethers.parseEther("1");  

    // console.log(currentTimestampInSecond);
    // console.log(ONE_YEAR_IN_SECONDS);
    console.log(unlockedTime);
    // console.log(lockedAmount);

    const MyTest = await hre.ethers.getContractFactory("MyTest");
    const myTest = await MyTest.deploy(unlockedTime, { value: lockedAmount });

    await myTest.waitForDeployment();
    
    console.log("Contract contains 1 ETH & address: ", await myTest.getAddress());
    // console.log(myTest);
}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1;
});