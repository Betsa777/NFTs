// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MoodInteractions is Script {
    MoodNft moodNft;

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );
        mintMoodNft(mostRecentlyDeployed);
    }

    function mintMoodNft(address smartAddress) private {
        vm.startBroadcast();
        MoodNft(smartAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlipMood is Script {
    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNft",
            block.chainid
        );
        flipMood(mostRecentlyDeployed);
    }

    function flipMood(address smartContract) private {
        // vm.startBroadcast();
        // MoodNft(smartContract).flipMood(0);
        // vm.stopBroadcast();
        console.log(MoodNft(smartContract).tokenURI(0));
    }
}
