// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract Config{
    struct NetworkConfig{
        address priceFeed;
    }

    NetworkConfig public networkConfig;

    constructor(){
        if(block.chainid == 11155111){
            networkConfig = getSepoliaConfig();
        } else if(block.chainid == 1101){
            networkConfig = getPolygonZKConfig();
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

    // function getAnvilConfig() public pure returns (NetworkConfig memory){}
}