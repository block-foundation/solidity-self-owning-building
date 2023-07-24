// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.19;


// ============================================================================
// Contracts
// ============================================================================

contract SelfOwningBuilding {


    // Parameters
    // ========================================================================

    address public owner;
    uint256 public price;
    uint256 public rent;
    uint256 public maintenanceCost;
    uint256 public lastRentPayment;
    uint256 public lastMaintenancePayment;
    uint256 public penaltyFee;

    // Constructor
    // ========================================================================

    constructor(
        uint256 _price,
        uint256 _rent,
        uint256 _maintenanceCost,
        uint256 _penaltyFee
    ) {
        owner = address(this);
        price = _price;
        rent = _rent;
        maintenanceCost = _maintenanceCost;
        penaltyFee = _penaltyFee;
        lastRentPayment = block.timestamp;
        lastMaintenancePayment = block.timestamp;
    }

    // Events
    // ========================================================================

    event PaidRent(
        address indexed tenant,
        uint256 amount
    );

    event PaidMaintenance(
        address indexed provider,
        uint256 amount
    );

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );


    // Modifiers
    // ========================================================================

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner can call this function."
        );
        _;
    }

    // Methods
    // ========================================================================

    function payRent() external payable {
        require(
            msg.value >= rent, "Insufficient payment for rent.");

        if(block.timestamp > lastRentPayment + 30 days) {
            require(
                msg.value >= rent + penaltyFee,
                "Late rent payment, penalty fee added."
            );
        }

        lastRentPayment = block.timestamp;
        emit PaidRent(msg.sender, msg.value);
    }

    function payMaintenance() external payable {
        require(
            msg.value >= maintenanceCost,
            "Insufficient payment for maintenance."
        );

        if(block.timestamp > lastMaintenancePayment + 30 days) {
            require(
                msg.value >= maintenanceCost + penaltyFee,
                "Late maintenance payment, penalty fee added."
            );
        }

        lastMaintenancePayment = block.timestamp;
        emit PaidMaintenance(msg.sender, msg.value);

    }

    function transferOwnership(
        address newOwner
    ) external onlyOwner {
        require(
            newOwner != address(0),
            "New owner is the zero address."
        );
        require(
            block.timestamp <= lastRentPayment + 30 days,
            "Rent payment overdue, cannot transfer ownership."
        );
        require(
            block.timestamp <= lastMaintenancePayment + 30 days,
            "Maintenance payment overdue, cannot transfer ownership."
        );
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function buyBuilding() external payable {
        require(
            msg.value == price,
            "You need to pay the exact price."
        );
        transferOwnership(msg.sender);
    }

    // Function to withdraw funds
    // ------------------------------------------------------------------------

    function withdraw() external onlyOwner {
        require(
            block.timestamp <= lastRentPayment + 30 days,
            "Rent payment overdue, cannot withdraw funds."
        );
        require(
            block.timestamp <= lastMaintenancePayment + 30 days,
            "Maintenance payment overdue, cannot withdraw funds."
        );
        payable(owner).transfer(address(this).balance);
    }

}
