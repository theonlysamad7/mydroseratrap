// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AdminExitTrap.sol";
import "../src/TVLAdapter.sol";
import "../src/DummyProtocol.sol";

contract AdminExitTrapTest is Test {
    AdminExitTrap trap;
    TVLAdapter adapter;
    DummyProtocol protocol;

    address guardian = address(0xBEEF);
    address attacker = address(0xBAD);

    function setUp() public {
        adapter = new TVLAdapter();
        trap = new AdminExitTrap(guardian, address(adapter), 10); // 10% threshold
        protocol = new DummyProtocol();
    }

    function testSafeWithdrawal() public {
        vm.startPrank(protocol.owner());
        protocol.withdraw(address(0x1234), 5 ether); // 5 < 100 threshold
        vm.stopPrank();

        bool triggered = trap.check(address(protocol), address(0x1234), 5 ether);
        assertFalse(triggered);
    }

    function testLargeWithdrawalTriggers() public {
        vm.startPrank(protocol.owner());
        protocol.withdraw(attacker, 200 ether); // 200 > 100 threshold
        vm.stopPrank();

        bool triggered = trap.check(address(protocol), attacker, 200 ether);
        assertTrue(triggered);
    }
}
