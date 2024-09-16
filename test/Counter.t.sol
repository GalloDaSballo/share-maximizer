// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TroveManager} from "../src/TroveManager.sol";

contract CounterTest is Test {
    TroveManager public tm;

    function setUp() public {
        tm = new TroveManager();
    }
}
