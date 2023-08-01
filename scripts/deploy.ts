// Copyright 2023 Stichting Block Foundation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.




import { ethers } from 'hardhat';

/**
 * This function deploys the SelfOwningBuilding contract to the Ethereum network.
 * Initial parameters for the contract are set within this function, and can be 
 * modified as needed.
 */
async function main() {
  // Get the Contract Factory
  // The Contract Factory allows us to deploy new instances of the contract to the network
  const SelfOwningBuildingFactory = await ethers.getContractFactory('SelfOwningBuilding');

  // Define initial parameters for the contract
  // These parameters set the initial state of the contract upon deployment
  const price = 500; // The initial price of the building
  const rent = 100; // The initial rent for the building
  const maintenanceCost = 50; // The initial maintenance cost for the building
  const penaltyFee = 10; // The initial penalty fee for the building

  // Deploy the contract with the initial values
  // This operation sends a transaction to the Ethereum network
  const contract = await SelfOwningBuildingFactory.deploy(price, rent, maintenanceCost, penaltyFee);

  // Wait for the contract to be deployed
  // This operation waits for the Ethereum network to mine the transaction
  await contract.deployed();

  console.log('Contract deployed to:', contract.address); // Output the address of the deployed contract
}

// Call the main function and handle any errors
// This pattern is commonly used in Node.js scripts to ensure any unhandled
// Promise rejections (async errors) are properly dealt with.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
