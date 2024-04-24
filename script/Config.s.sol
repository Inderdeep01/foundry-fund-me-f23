// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract Config is Script{
    struct NetworkConfig{
        address priceFeed;
    }

    // Constants for deploying mock Aggregator
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 400e8;

    // This will contain the configuration as per the chain you decide to deploy the contract on
    // Networks are detected using the chainid
    NetworkConfig public networkConfig;

    constructor(){
        if(block.chainid == 11155111){
            networkConfig = getSepoliaConfig();
        } else if(block.chainid == 1101){
            networkConfig = getPolygonZKConfig();
        } else {
            networkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getPolygonZKConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory polygonZKConfig = NetworkConfig({ priceFeed: 0x97d9F9A00dEE0004BE8ca0A8fa374d486567eE2D });
        return polygonZKConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory){
        if(networkConfig.priceFeed != address(0)){
            return networkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({ priceFeed: address(mockPriceFeed) });
        return anvilConfig;
    }
}