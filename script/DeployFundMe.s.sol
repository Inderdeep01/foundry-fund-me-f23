// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Config} from "./Config.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe){
        Config activeConfig = new Config();
        address priceFeed = activeConfig.networkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}