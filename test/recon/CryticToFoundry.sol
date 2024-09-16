// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console2.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();
    }

    uint256 constant MIN_DEBT = 2000e18;
    // OBSERVATION:
    // If we could mint zero shares, we can fibonacci the debt

    // Because we cannot
    // The error is in the amount of shares minted
    // And in the amount of debt assigned to us
    // Due to the size of operations, this tends to be 1 unit

    // I'm having a hard time making this grow above that size

    // FINDING: We can repay until the error is undone
    // We do not get a reduction of shares
    // We instead globally reduce the debt for the Batch


    function _logDebtAndShares() internal {
        console2.log("");
        console2.log("totalBatchDebt", tm.totalBatchDebt());
        console2.log("totalDebtShares", tm.totalDebtShares());
    }
}
