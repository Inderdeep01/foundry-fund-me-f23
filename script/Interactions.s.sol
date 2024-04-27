// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VAL = 1 ether;

    function fundFundMe(address latestDeployment) public {
        vm.startBroadcast();
        FundMe(payable(latestDeployment)).fund{value: SEND_VAL}();
        vm.stopBroadcast();
        console.log("Funded");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VAL = 0.01 ether;

    function withdrawFundMe(address latestDeployment) public {
        vm.startBroadcast();
        FundMe(payable(latestDeployment)).withdraw();
        vm.stopBroadcast();
        console.log("Funded");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}