// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundMe.sol";
import {Helper} from "./Helper.s.sol";

contract fundMeS is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast --> not a "real" tx
        Helper helper = new Helper();
        address EthUsdPrice = helper.activeConfig();

        // After startBroadcast --> a "real" tx
        vm.startBroadcast();
        FundMe fundMe = new FundMe(EthUsdPrice);
        vm.stopBroadcast();
        return fundMe;
    }
}
