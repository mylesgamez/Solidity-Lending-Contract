const Lending = artifacts.require("Lending");
const IERC20 = artifacts.require("IERC20");
const { expect } = require('chai');

contract("Lending", (accounts) => {
    let lending;
    const owner = accounts[0];
    const borrower = accounts[1];
    const anotherAccount = accounts[2];
    const principal = 1000;
    const period = 7 * 24 * 60 * 60; // 7 days in seconds
    const interestRate = 10;
    const interest = (principal * interestRate) / 100;

    before(async () => {
        lending = await Lending.deployed();
    });

    it("should lend money", async () => {
        await lending.lend(borrower, principal, period, { from: owner });
        const loan = await lending.loans(borrower);
        expect(Number(loan.principal)).to.equal(principal);
        expect(Number(loan.interest)).to.equal(interest);
    });

    it("should allow borrower to deposit collateral", async () => {
        // Replace the below token address with your deployed ERC20 token contract address
        const tokenAddress = "0xYOUR_TOKEN_CONTRACT_ADDRESS_HERE";
        const collateralAmount = 2000;
        const token = await IERC20.at(tokenAddress);
        await token.approve(lending.address, collateralAmount, { from: borrower });
        await lending.depositCollateral(tokenAddress, collateralAmount, { from: borrower });
        const loan = await lending.loans(borrower);
        expect(loan.collateralToken).to.equal(tokenAddress);
        expect(Number(loan.collateralAmount)).to.equal(collateralAmount);
    });
});
