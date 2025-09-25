// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Dummy protocol to simulate withdrawals
contract DummyProtocol {
    address public owner;
    uint256 public reserves;

    event Withdraw(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
        reserves = 1000 ether;
    }

    function withdraw(address to, uint256 amount) external {
        require(msg.sender == owner, "Not owner");
        require(amount <= reserves, "Not enough reserves");
        reserves -= amount;
        emit Withdraw(to, amount);
    }
}
