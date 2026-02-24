// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletScript is Script {
    Wallet public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new Wallet();

        vm.stopBroadcast();
    }
}
