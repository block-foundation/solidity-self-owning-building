// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract SelfOwningBuilding {
    // Define variables
    address public owner;
    uint256 public price;
    uint256 public rent;
    uint256 public maintenanceCost;

    // Constructor
    constructor(uint256 _price, uint256 _rent, uint256 _maintenanceCost) {
        owner = address(this);
        price = _price;
        rent = _rent;
        maintenanceCost = _maintenanceCost;
    }

    // Events
    event PaidRent(address indexed tenant, uint256 amount);
    event PaidMaintenance(address indexed provider, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Methods
    function payRent() external payable {
        require(msg.value == rent, "You need to pay the exact rent.");
        emit PaidRent(msg.sender, msg.value);
    }

    function payMaintenance() external payable {
        require(msg.value == maintenanceCost, "You need to pay the exact maintenance cost.");
        emit PaidMaintenance(msg.sender, msg.value);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is the zero address.");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function buyBuilding() external payable {
        require(msg.value == price, "You need to pay the exact price.");
        transferOwnership(msg.sender);
    }

    // Function to withdraw funds
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
