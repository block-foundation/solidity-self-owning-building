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



// Importing necessary modules and types
import { ethers } from "hardhat";
import chai from "chai";
import { solidity } from "ethereum-waffle";
import { SelfOwningBuilding } from "../typechain/SelfOwningBuilding";

chai.use(solidity);
const { expect } = chai;

// Test suite for the SelfOwningBuilding contract
describe("Self Owning Building", () => {
  // Variable to hold the deployed contract instance
  let selfOwningBuilding: SelfOwningBuilding;

  // Before each test, we deploy a new SelfOwningBuilding contract instance
  beforeEach(async () => {
    const SelfOwningBuildingFactory = await ethers.getContractFactory("SelfOwningBuilding");
    selfOwningBuilding = await SelfOwningBuildingFactory.deploy(500, 100, 50, 10) as SelfOwningBuilding;
    await selfOwningBuilding.deployed();
  });

  // Test case to verify correct initialization of the contract
  it("Should correctly initialize with provided values", async () => {
    expect(await selfOwningBuilding.owner()).to.eq(selfOwningBuilding.address);
    expect(await selfOwningBuilding.price()).to.eq(500);
    expect(await selfOwningBuilding.rent()).to.eq(100);
    expect(await selfOwningBuilding.maintenanceCost()).to.eq(50);
    expect(await selfOwningBuilding.penaltyFee()).to.eq(10);
  });

  // Test case to verify the functionality of rent payment
  it("Should allow payment of rent", async () => {
    const [owner, tenant] = await ethers.getSigners();

    await selfOwningBuilding.connect(owner).addTenant(tenant.address);

    await expect(selfOwningBuilding.connect(tenant).payRent({ value: 100 }))
      .to.emit(selfOwningBuilding, "PaidRent")
      .withArgs(tenant.address, 100);
  });

  // Test case to verify the adjustment of rent, maintenance cost, and penalty fee
  it("Should allow adjustment of rent, maintenance cost and penalty fee", async () => {
    const [owner] = await ethers.getSigners();
    await selfOwningBuilding.connect(owner).adjustFees(200, 100, 20);

    expect(await selfOwningBuilding.rent()).to.eq(200);
    expect(await selfOwningBuilding.maintenanceCost()).to.eq(100);
    expect(await selfOwningBuilding.penaltyFee()).to.eq(20);
  });

  // Test case to verify that non-owners can't adjust fees
  it("Should not allow non-owners to adjust fees", async () => {
    const [, nonOwner] = await ethers.getSigners();
    await expect(selfOwningBuilding.connect(nonOwner).adjustFees(200, 100, 20)).to.be.revertedWith("Only the owner can call this function.");
  });

  // Test case to verify adding and removing of tenants
  it("Should allow adding and removing tenants", async () => {
    const [owner, tenant] = await ethers.getSigners();

    await selfOwningBuilding.connect(owner).addTenant(tenant.address);
    expect(await selfOwningBuilding.tenants(tenant.address)).to.be.true;

    await selfOwningBuilding.connect(owner).removeTenant(tenant.address);
    expect(await selfOwningBuilding.tenants(tenant.address)).to.be.false;
  });

  // Test case to verify that non-owners can't add or remove tenants
  it("Should not allow non-owners to add or remove tenants", async () => {
    const [, nonOwner, tenant] = await ethers.getSigners();

    await expect(selfOwningBuilding.connect(nonOwner).addTenant(tenant.address)).to.be.revertedWith("Only the owner can call this function.");
    await expect(selfOwningBuilding.connect(nonOwner).removeTenant(tenant.address)).to.be.revertedWith("Only the owner can call this function.");
  });

  // Test case to verify the withdrawal of funds by the owner
  it("Should allow the owner to withdraw funds", async () => {
    const [owner, tenant] = await ethers.getSigners();

    await selfOwningBuilding.connect(owner).addTenant(tenant.address);
    await selfOwningBuilding.connect(tenant).payRent({ value: ethers.utils.parseEther("1") });

    const initialBalance = await owner.getBalance();
    await selfOwningBuilding.connect(owner).withdraw();
    const finalBalance = await owner.getBalance();

    expect(finalBalance).to.be.gt(initialBalance);
  });

  // Test case to verify the buying of the building
  it("Should allow the buyer to buy the building", async () => {
    const [_, buyer] = await ethers.getSigners();
    await expect(selfOwningBuilding.connect(buyer).buyBuilding({ value: 500 }))
      .to.emit(selfOwningBuilding, "OwnershipTransferred")
      .withArgs(selfOwningBuilding.address, buyer.address);

    expect(await selfOwningBuilding.owner()).to.eq(buyer.address);
  });

  // Test case to verify that buying is not allowed with insufficient funds
  it("Should not allow the buyer to buy the building with insufficient funds", async () => {
    const [_, buyer] = await ethers.getSigners();
    await expect(selfOwningBuilding.connect(buyer).buyBuilding({ value: 499 }))
      .to.be.revertedWith("You need to pay the exact price.");
  });

  // Test case to verify that fund withdrawal is not allowed if rent payment is overdue
  it("Should not allow the owner to withdraw funds if rent payment is overdue", async () => {
    const [owner, tenant] = await ethers.getSigners();

    await selfOwningBuilding.connect(owner).addTenant(tenant.address);
    await ethers.provider.send("evm_increaseTime", [31 * 24 * 60 * 60]); // Advance time by 31 days
    await ethers.provider.send("evm_mine", []); // Mine the next block

    await expect(selfOwningBuilding.connect(owner).withdraw())
      .to.be.revertedWith("Rent payment overdue, cannot withdraw funds.");
  });

  // Test case to verify that ownership transfer is not allowed if maintenance payment is overdue
  it("Should not allow the owner to transfer ownership if maintenance payment is overdue", async () => {
    const [owner, newOwner] = await ethers.getSigners();

    await ethers.provider.send("evm_increaseTime", [31 * 24 * 60 * 60]); // Advance time by 31 days
    await ethers.provider.send("evm_mine", []); // Mine the next block

    await expect(selfOwningBuilding.connect(owner).transferOwnership(newOwner.address))
      .to.be.revertedWith("Maintenance payment overdue, cannot transfer ownership.");
  });


});
