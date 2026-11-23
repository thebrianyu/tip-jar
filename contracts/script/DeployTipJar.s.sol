// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {TipJar} from "../src/TipJar.sol";

/// Deploys TipJar. The wallet that runs this becomes the owner.
contract DeployTipJar is Script {
    function run() external returns (TipJar jar) {
        // Read the key from the environment (.env). Never hard-code it here.
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        // Everything between start and stop becomes a real, signed transaction.
        vm.startBroadcast(deployerKey);
        jar = new TipJar();
        vm.stopBroadcast();

        console.log("TipJar deployed at:", address(jar));
        console.log("Owner:", jar.owner());
    }
}
