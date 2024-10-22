// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    string public svgHappy;
    string public svgSad;
    MoodNft moodNft;

    function run() public returns (MoodNft) {
        svgHappy = vm.readFile("./images/dynamicNft/happy.svg");
        svgSad = vm.readFile("./images/dynamicNft/sad.svg");
        vm.startBroadcast();
        moodNft = new MoodNft(svgToImageUri(svgSad), svgToImageUri(svgHappy));
        vm.stopBroadcast();
        return moodNft;
    }

    function baseUri() private pure returns (string memory) {
        return "data:image/svg+xml;base64,";
    }

    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        //pass svg like <svg viewBox="0 0 200 200" width="400" ...abi
        //return data:image/svg+xml;base64,...(base64 input svg result)
        string memory svgBase64Encoded = Base64.encode(abi.encodePacked(svg));
        return string(abi.encodePacked(baseUri(), svgBase64Encoded));
    }
}
