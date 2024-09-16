// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {
    uint256 maxId;

    function troveManager_mockInterest(uint256 newAmt) public {
        tm.mockInterest(newAmt);
    }

    function troveManager_mockRedeem(uint256 idEntropy, uint256 amt) public {
        uint256 id = idEntropy % maxId + 1;

        tm.mockRedeem(id, amt);
    }

    function troveManager_onOpenTroveAndJoinBatch(uint256 newDebt) public {
        tm.onOpenTroveAndJoinBatch(newDebt);
        maxId++;
    }

    // TODO: Make it a b4 after
    function troveManager_increaseDebt_withCheck(uint256 idEntropy, uint256 newDebt) public {
        uint256 id = idEntropy % maxId + 1;

        uint256 debtB4 = tm.totalBatchDebt();
        uint256 sharesBefore = tm.totalDebtShares();
        tm.increaseDebt(id, newDebt);

        if (
            sharesBefore == tm.totalDebtShares() // No new shares
        ) {
            if(debtB4 != tm.totalBatchDebt()) {
                uint256 delta = tm.totalBatchDebt() > debtB4 ? tm.totalBatchDebt()  - debtB4  : debtB4 - tm.totalBatchDebt();
                if(delta > maxValue){
                    maxValue = delta;
                }
            }
        }
    }

    function troveManager_closeTrove(uint256 idEntropy) public {
        uint256 id = idEntropy % maxId + 1;
        tm.closeTrove(id);
    }

    uint256 maxValue;

    function optimize_forgivenDebt() public returns (int256) {
        return int256(maxValue);
    }


    // TODO Once we add remove
    function check_global() public {
        if (tm.totalDebtShares() == 0) {
            t(tm.totalBatchDebt() == 0, "Not Debt stuck"); 
        }
    }

    function optimize_ppfs() public returns (int256) {
        return int256(tm.totalBatchDebt()) * int256(1e18) / int256(tm.totalDebtShares());
    }
}
