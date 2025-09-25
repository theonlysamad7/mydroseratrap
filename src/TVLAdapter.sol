// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAdapter.sol";

/// @notice Example adapter that queries a protocol’s reserves
contract TVLAdapter is IAdapter {
    function getTVL(address protocol) external pure override returns (uint256) {
        // For demo, return dummy TVL (1000 ETH)
        // In real use, call protocol-specific functions
        return 1000 ether;
    }
}
