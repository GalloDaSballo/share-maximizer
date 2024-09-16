// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import "src/TroveManager.sol";

abstract contract Setup is BaseSetup {
    TroveManager tm;

    function setup() internal virtual override {
        tm = new TroveManager();
    }
}
