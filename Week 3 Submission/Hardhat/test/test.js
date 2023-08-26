const { 
    time, 
    loadFixture, 
} = require("@nomicfoundation/hardhat-network-helpers");
// npx hardhat test

// console.log(time);
// console.log(loadFixture);

const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
// console.log(anyValue);

const { expect } = require("chai");
const { ethers } = require("hardhat");
// console.log(expect);

describe("MyTest", function() {
    async function runEveryTime() {
        const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
        const ONE_GWEI = 1000000000;

        const LOCKED_AMOUNT = ONE_GWEI;
        const UNLOCKED_TIME = (await time.latest()) + ONE_YEAR_IN_SECONDS;
        
        
        // console.log(ONE_YEAR_IN_SECONDS, ONE_GWEI);
        // console.log(LOCKED_AMOUNT);


        // GET ACCOUNTS
        const [owner, otherAccount] = await ethers.getSigners();
        // console.log(owner);
        // owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        // otherAccount: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        // console.log(otherAccount);

        const MyTest = await ethers.getContractFactory("MyTest");
        const myTest = await MyTest.deploy(UNLOCKED_TIME, { value: LOCKED_AMOUNT });
        
        // await myTest.waitForDeployment();
        // console.log(myTest, unlockedTime, )

        return { myTest, UNLOCKED_TIME, LOCKED_AMOUNT, owner, otherAccount }
    }

    describe("Deployment", function() {
        it("Should check unlocked time", async function() {
            const { myTest, UNLOCKED_TIME } = await loadFixture(runEveryTime);

            // console.log(myTest);
            // console.log(UNLOCKED_TIME);
            expect(await myTest.unlockedTime()).to.equal(UNLOCKED_TIME);
        });
    });

    runEveryTime();
});