# Solidity Lending Smart Contract

## Description
A decentralized lending platform implemented in Solidity. The platform allows users to request loans, deposit collateral, repay loans, and liquidate collateral in case of default. It also includes interest calculations and collateral management.

## Project Structure
- `contracts/`: Contains the Solidity smart contract (`Lending.sol`).
- `test/`: Contains the test file (`testLending.js`) to test the smart contract functionalities.
- `migrations/`: Contains the deployment script (`2_deploy_lending.js`) for deploying the smart contract.
- `node_modules/`: Contains the project dependencies.
- `package-lock.json` & `package.json`: Contains the list of dependencies and other metadata.
- `truffle-config.js`: Truffle configuration file.

## How to Run
1. Clone the repository: 
git clone https://github.com/YourUsername/solidity-lending.git

2. Navigate to the project directory: 
cd solidity-lending

3. Install dependencies:
npm install

4. Compile the contracts:
truffle compile

5. Deploy the contracts:
truffle migrate

6. Test the contracts:
truffle test


## Dependencies
- OpenZeppelin Contracts: For using the `IERC20` interface for ERC20 tokens.
- Truffle: For compiling, deploying, and testing the smart contracts.
- Node.js: For managing project dependencies.

## License
MIT
