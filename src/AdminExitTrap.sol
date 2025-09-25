// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAdapter.sol";

/// @title AdminExitTrap
/// @notice Trap that detects suspicious large transfers or admin withdrawals.
contract AdminExitTrap {
    address public guardian;
    IAdapter public adapter;

    // % of TVL allowed before trigger (e.g. 10 = 10%)
    uint256 public thresholdPercent;

    mapping(address => bool) public whitelist;

    event Triggered(address indexed protocol, address indexed target, uint256 amount);
    event WhitelistUpdated(address indexed addr, bool allowed);
    event AdapterUpdated(address indexed newAdapter);
    event ThresholdUpdated(uint256 newThreshold);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not guardian");
        _;
    }

    constructor(address _guardian, address _adapter, uint256 _thresholdPercent) {
        guardian = _guardian;
        adapter = IAdapter(_adapter);
        thresholdPercent = _thresholdPercent;
    }

    /// @notice Add/remove whitelist address
    function setWhitelist(address addr, bool allowed) external onlyGuardian {
        whitelist[addr] = allowed;
        emit WhitelistUpdated(addr, allowed);
    }

    /// @notice Update adapter
    function setAdapter(address _adapter) external onlyGuardian {
        adapter = IAdapter(_adapter);
        emit AdapterUpdated(_adapter);
    }

    /// @notice Update threshold %
    function setThreshold(uint256 _percent) external onlyGuardian {
        thresholdPercent = _percent;
        emit ThresholdUpdated(_percent);
    }

    /// @notice Core logic to check suspicious transfer
    function check(address protocol, address target, uint256 amount) external returns (bool) {
        if (whitelist[target]) {
            return false; // safe
        }

        uint256 tvl = adapter.getTVL(protocol);
        uint256 maxAllowed = (tvl * thresholdPercent) / 100;

        if (amount >= maxAllowed) {
            emit Triggered(protocol, target, amount);
            return true; // suspicious
        }
        return false;
    }
}
