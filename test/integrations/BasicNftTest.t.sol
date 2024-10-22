// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft b;
    address public USER = makeAddr("user");
    string private s_tokenUri =
        "https://ipfs.io/ipfs/QmWhiiZWEB1fDE9Yh9xi7zQWN1rcAu1cXbQjdvsvcaME4K";

    function setUp() public {
        //ca c'est un test d'integration parce qu'on utilise le deployer
        deployer = new DeployBasicNft();
        b = deployer.run();
    }

    function testName() public view {
        string memory expectedName = "Dogie";
        string memory actualName = b.name();
        assertEq(
            keccak256(abi.encodePacked(expectedName)),
            keccak256(abi.encodePacked(actualName))
        );
    }

    function testMintNft() public {
        vm.prank(msg.sender);
        b.mintNft(s_tokenUri);
        assertEq(b.balanceOf(msg.sender), 1);
        assertEq(
            keccak256(abi.encodePacked(s_tokenUri)),
            keccak256(abi.encodePacked(b.tokenURI(0)))
        );
    }
}
