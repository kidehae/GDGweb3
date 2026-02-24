// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";
contract WalletTest is Test {
    Wallet public wallet;

    address student = address(1);
    address otherUser = address(2);

    function setUp() public {
        vm.prank(student);
        wallet = new Wallet();
    }

    function test_DepositGreaterThan50() public {
        vm.deal(student, 100);

        vm.prank(student);
        wallet.deposit{value: 100}();

        assertEq(wallet.getBalance(), 100);
    }

    function test_RevertIf_DepositLessThanOrEqual50() public {
        vm.deal(student, 50);

        vm.prank(student);
        vm.expectRevert("Deposit must be > 50");
        wallet.deposit{value: 50}();
    }

    function test_WithdrawChecksNonZeroAddress() public {
        vm.deal(student, 100);

        vm.startPrank(student);
        wallet.deposit{value: 100}();
        wallet.withdraw(100);
        vm.stopPrank();

        assertEq(wallet.getBalance(), 0);
    }
}