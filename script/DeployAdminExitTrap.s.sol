// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AdminExitTrap.sol";
import "../src/TVLAdapter.sol";

contract DeployAdminExitTrap is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TVLAdapter adapter = new TVLAdapter();
        AdminExitTrap trap = new AdminExitTrap(msg.sender, address(adapter), 10);

        vm.stopBroadcast();
    }
}
