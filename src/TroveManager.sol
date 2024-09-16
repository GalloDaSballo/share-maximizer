// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {TroveChange} from "./TroveChange.sol";

contract TroveManager {
    // Trove

    // Batches

    // Open
    // Close
    // Adjust
    // Add interest

    // Add
    // Rebase
    // Update

    uint256 public totalBatchDebt;
    uint256 public totalDebtShares;
    mapping (uint256 => uint256) debtShares;

    // function to get debt
    // function to close trove and repay

    function getTroveDebt(uint256 id) public returns (uint256) {
        uint256 batchDebtShares = debtShares[id];
        return totalBatchDebt * batchDebtShares / totalDebtShares;
    }



    uint256 public constant MIN_DEBT = 2000e18;

    uint256 newIds;
    mapping (uint256 => bool) openIds;



    function onOpenTroveAndJoinBatch(uint256 newDebt) public {
        // require(newDebt >= MIN_DEBT);
        require(newDebt < type(uint128).max);

        updateBatchShares(++newIds, newDebt, 0);
        openIds[newIds] = true;
    }

    function mockRedeem(uint256 troveId, uint256 amt) public {
        require(openIds[troveId]);
        // Reduce debt linearly
        require(amt <= totalBatchDebt);

        updateBatchShares(troveId, 0, amt);
    }

    function mockInterest(uint256 newMultiplier) public {
        require(newMultiplier < 1e18);
        totalBatchDebt += totalBatchDebt * newMultiplier / 1e18;
    }
    function manualAddIntest(uint256 add) public {
        totalBatchDebt += add;
    }

    function increaseDebt(uint256 troveId, uint256 newDebt) public {
        require(openIds[troveId]);
        updateBatchShares(troveId, newDebt, 0);
    }

    event EmitString(string);
    function closeTrove(uint256 troveId) public {
        require(openIds[troveId]);

        // Repay the debt
        uint256 toReduce = getTroveDebt(troveId);

        if(toReduce > totalBatchDebt) {
            emit EmitString("Overflow Debt");
        }
        totalBatchDebt -= toReduce;
        
        if(debtShares[troveId] > totalDebtShares) {
            emit EmitString("Overflow Shares");
        }
        totalDebtShares -= debtShares[troveId];

        // Reduce the total Shares

        openIds[troveId] = false;
    }

    // TODO: Make it work with mappings
    function updateBatchShares(uint256 troveId, uint256 debtIncrease, uint256 debtDecrease) internal {
        // Debt
        uint256 currentBatchDebtShares = totalDebtShares;

        uint256 batchDebtSharesDelta;

        if (debtIncrease > debtDecrease) {
            debtIncrease -= debtDecrease;
        } else {
            debtDecrease = debtDecrease - debtIncrease;
            debtIncrease = 0;
        }

        if (debtIncrease == 0 && debtDecrease == 0) {
            totalBatchDebt = totalBatchDebt;
        } else {
            if (debtIncrease > 0) {
                // Add debt
                if (totalBatchDebt == 0) {
                    batchDebtSharesDelta = debtIncrease;
                } else { // 666730593607186700349 * increase / 2000191780821560101049
                    batchDebtSharesDelta = currentBatchDebtShares * debtIncrease / totalBatchDebt; // 0 * Increase / Total
                }

                debtShares[troveId] += batchDebtSharesDelta;
                totalBatchDebt = totalBatchDebt + debtIncrease;
                totalDebtShares = currentBatchDebtShares + batchDebtSharesDelta;
            } else if (debtDecrease > 0) {
                // Subtract debt
                batchDebtSharesDelta = currentBatchDebtShares * debtDecrease / totalBatchDebt;

                debtShares[troveId] -= batchDebtSharesDelta;
                totalBatchDebt = totalBatchDebt - debtDecrease;
                totalDebtShares = currentBatchDebtShares - batchDebtSharesDelta;
            }
        }
    }

    // Rem
}
