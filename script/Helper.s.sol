// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract Helper is Script {
    Config public activeConfig;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct Config {
        address priceFeed; // Eth/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaConfig();
        } else if (block.chainid == 534351) {
            activeConfig = getScrollSepConfig();
        } else if (block.chainid == 11155420) {
            activeConfig = getOptimismSepConfig();
        } else {
            activeConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (Config memory) {
        Config memory sepolia = Config({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return (sepolia);
        // Price feed address
    }

    function getScrollSepConfig() public pure returns (Config memory) {
        Config memory scrollSep = Config({
            priceFeed: 0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41
        });
        return (scrollSep);
    }

    function getOptimismSepConfig() public pure returns (Config memory) {
        Config memory optimismSep = Config({
            priceFeed: 0x61Ec26aA57019C486B10502285c5A3D4A4750AD7
        });
        return (optimismSep);
    }

    function getAnvilConfig() public returns (Config memory) {
        if (activeConfig.priceFeed != address(0)) {
            return activeConfig;
        }
        // price Feed address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        Config memory anvil = Config({priceFeed: address(mockPriceFeed)});
        return (anvil);
    }
}
