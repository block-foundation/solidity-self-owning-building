// SPDX-License-Identifier: Apache-2.0


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


pragma solidity ^0.8.19;


// ============================================================================
// Contracts
// ============================================================================
/// @title SelfOwningBuilding
/// @dev A contract representing a building that can be owned by itself or other addresses.
contract SelfOwningBuilding {


    // Parameters
    // ========================================================================
    
    /// @notice The address of the current owner of the building.
    address public owner;
    
    /// @notice The price to purchase the building.
    uint256 public price;
    
    /// @notice The rent cost that must be paid by tenants.
    uint256 public rent;
    
    /// @notice The cost of maintenance for the building.
    uint256 public maintenanceCost;
    
    /// @notice The timestamp of the last rent payment.
    uint256 public lastRentPayment;
    
    /// @notice The timestamp of the last maintenance payment.
    uint256 public lastMaintenancePayment;
    
    /// @notice The fee that is charged if a payment is late.
    uint256 public penaltyFee;
    
    /// @notice A mapping to track the tenants in the building.
    mapping(address => bool) public tenants;
    
    /// @notice The total number of tenants in the building.
    uint256 public totalTenants;


    // Constructor
    // ========================================================================

    /// @notice Creates a new SelfOwningBuilding contract.
    /// @param _price The price to purchase the building.
    /// @param _rent The rent cost that must be paid by tenants.
    /// @param _maintenanceCost The cost of maintenance for the building.
    /// @param _penaltyFee The fee that is charged if a payment is late.
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

    /// @notice An event that gets emitted when a tenant pays rent.
    /// @param tenant The address of the tenant who paid the rent.
    /// @param amount The amount of rent paid.
    event PaidRent(
        address indexed tenant,
        uint256 amount
    );

    /// @notice An event that gets emitted when maintenance is paid.
    /// @param provider The address of the service provider who did the maintenance.
    /// @param amount The amount of maintenance cost paid.
    event PaidMaintenance(
        address indexed provider,
        uint256 amount
    );

    /// @notice An event that gets emitted when the ownership of the building is transferred.
    /// @param previousOwner The address of the previous owner of the building.
    /// @param newOwner The address of the new owner of the building.
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /// @notice An event that gets emitted when a new tenant is added.
    /// @param newTenant The address of the new tenant.
    event TenantAdded(
        address indexed newTenant
    );

    /// @notice An event that gets emitted when a tenant is removed.
    /// @param removedTenant The address of the removed tenant.
    event TenantRemoved(
        address indexed removedTenant
    );


    // Modifiers
    // ========================================================================

    /// @notice A modifier to make a function callable only by the owner.
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner can call this function."
        );
        _;
    }

    /// @notice A modifier to make a function callable only by a tenant.
    modifier onlyTenant() {
        require(
            tenants[msg.sender] == true,
            "Only tenants can call this function."
        );
        _;
    }

    // Methods
    // ========================================================================

    /// @notice Allows a tenant to pay rent.
    /// @dev The payment must be equal to or greater than the rent amount.
    ///      If the rent is overdue, a penalty fee is added.
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

    /// @notice Allows a service provider to pay for maintenance.
    /// @dev The payment must be equal to or greater than the maintenance cost.
    ///      If the maintenance is overdue, a penalty fee is added.
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

    /// @notice Allows the owner to transfer ownership of the building.
    /// @dev The function can only be called by the current owner.
    ///      Ownership cannot be transferred if rent or maintenance payment is overdue.
    /// @param newOwner The address of the new owner.
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

    /// @notice Allows a user to buy the building.
    /// @dev The payment must be equal to the price of the building.
    function buyBuilding() external payable {
        require(
            msg.value == price,
            "You need to pay the exact price."
        );
        transferOwnership(msg.sender);
    }

    /// @notice Allows the owner to adjust the rent, maintenance cost, and penalty fee.
    /// @dev This function can only be called by the owner.
    /// @param _rent The new rent amount.
    /// @param _maintenanceCost The new maintenance cost.
    /// @param _penaltyFee The new penalty fee.
    function adjustFees(uint256 _rent, uint256 _maintenanceCost, uint256 _penaltyFee) external onlyOwner {
        rent = _rent;
        maintenanceCost = _maintenanceCost;
        penaltyFee = _penaltyFee;
    }

    /// @notice Allows the owner to add a new tenant.
    /// @dev This function can only be called by the owner.
    /// @param _tenant The address of the new tenant.
    function addTenant(address _tenant) external onlyOwner {
        require(tenants[_tenant] == false, "This address is already a tenant.");
        tenants[_tenant] = true;
        totalTenants++;
        emit TenantAdded(_tenant);
    }

    /// @notice Allows the owner to remove a tenant.
    /// @dev This function can only be called by the owner.
    /// @param _tenant The address of the tenant to remove.
    function removeTenant(address _tenant) external onlyOwner {
        require(tenants[_tenant] == true, "This address is not a tenant.");
        tenants[_tenant] = false;
        totalTenants--;
        emit TenantRemoved(_tenant);
    }

    /// @notice Allows the owner to withdraw all funds from the contract.
    /// @dev This function can only be called by the owner.
    ///      Funds cannot be withdrawn if rent or maintenance payment is overdue.
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

    /// @notice A fallback function to accept funds sent directly to the contract.
    fallback() external payable {}

}
