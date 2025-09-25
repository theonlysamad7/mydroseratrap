// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAdapter {
    function getTVL(address protocol) external view returns (uint256);
}
